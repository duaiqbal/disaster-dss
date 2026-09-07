import 'package:flutter/material.dart';
import '../../core/retrieval/retrieval_engine.dart';
import '../../core/rules_engine/rules_engine.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/app_translations.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  final List<String> recommendedSteps;
  final List<String> sources;
  final String? evidenceLevel;
  bool xaiExpanded = false;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.recommendedSteps = const [],
    this.sources = const [],
    this.evidenceLevel,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _loading = false;
  bool _isOnline = false;

  List<String> get _suggestionChips => [
    Tr.t('chip_why_risk'),
    Tr.t('chip_heavy_rain'),
    Tr.t('chip_what_pack'),
    Tr.t('chip_alert_mean'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitQuery(String queryText) async {
    final query = queryText.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: query, isUser: true));
      _loading = true;
    });
    _controller.clear();
    _scrollToBottom();

    String answerText;
    List<String> steps = [];
    List<String> sources = [];
    String? evidenceLabel;

    final apiResponse = await ApiService.post('/api/query', {'query': query});
    if (apiResponse != null && apiResponse['answer'] != null) {
      _isOnline = true;
      answerText = apiResponse['answer'] as String;
      if (apiResponse['recommended_steps'] is List) {
        steps = List<String>.from(apiResponse['recommended_steps'] as List);
      }
      if (apiResponse['sources'] is List) {
        sources = List<String>.from(
          (apiResponse['sources'] as List).map((s) => s.toString()),
        );
      }
    } else {
      _isOnline = false;
      final chunks = await RetrievalEngine.search(query);
      final response = RulesEngine.buildResponse(query, chunks, offline: true);
      answerText = response.answerText;
      evidenceLabel = _evidenceLabel(response.evidenceLevel);
      sources = response.sources
          .map((s) => '${s.sourceOrg}: ${s.sourceTitle}')
          .toList();
      if (steps.isEmpty) {
        steps = [
          Tr.t('offline_step_1'),
          Tr.t('offline_step_2'),
          Tr.t('offline_step_3'),
          Tr.t('offline_step_4'),
        ];
      }
    }

    setState(() {
      _messages.add(_ChatMessage(
        text: answerText,
        isUser: false,
        recommendedSteps: steps,
        sources: sources,
        evidenceLevel: evidenceLabel,
      ));
      _loading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _evidenceLabel(EvidenceLevel level) {
    switch (level) {
      case EvidenceLevel.high:
        return Tr.t('evidence_high');
      case EvidenceLevel.moderate:
        return Tr.t('evidence_moderate');
      case EvidenceLevel.limited:
        return Tr.t('evidence_limited');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildContextChips(),
          Expanded(child: _buildChatArea()),
          _buildDisclaimer(),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const BackButton(color: AppColors.textPrimary),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.t('chat_title'),
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.textPrimary,
              fontSize: 17,
            ),
          ),
          Text(
            Tr.t('chat_subtitle'),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _isOnline
                ? AppColors.onlineGreen.withValues(alpha: 0.12)
                : AppColors.border,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isOnline
                ? AppColors.onlineGreen.withValues(alpha: 0.4)
                : AppColors.textMuted.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: _isOnline ? AppColors.onlineGreen : AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                _isOnline ? Tr.t('chat_online') : Tr.t('chat_offline'),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _isOnline ? AppColors.onlineGreen : AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContextChips() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _contextChip(
              icon: Icons.location_on_outlined,
              label: Tr.t('chat_context_location'),
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            _contextChip(
              icon: Icons.warning_amber_rounded,
              label: Tr.t('chat_context_alert'),
              color: AppColors.riskHigh,
              bgColor: AppColors.riskHighBg,
              borderColor: AppColors.riskHighCardBorder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _contextChip({
    required IconData icon,
    required String label,
    required Color color,
    Color? bgColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    final bool isEmpty = _messages.isEmpty;
    final itemCount = (isEmpty ? 2 : _messages.length + 1) + (_loading ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) return _buildGreetingBubble();
        if (isEmpty && index == 1) return _buildSuggestionChips();
        final msgIndex = isEmpty ? index - 2 : index - 1;
        if (msgIndex >= 0 && msgIndex < _messages.length) {
          return _buildMessageBubble(_messages[msgIndex], msgIndex);
        }
        if (_loading) return _buildLoadingBubble();
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGreetingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aiAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                Tr.t('chat_greeting'),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: _suggestionChips
            .map(
              (chip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => _submitQuery(chip),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      chip,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg, int index) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 48),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              msg.text,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aiAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Text(
                      msg.text,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (msg.recommendedSteps.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.aiCardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.aiCardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Tr.t('chat_recommended_steps'),
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...msg.recommendedSteps.map(
                              (step) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        step,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textPrimary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _messages[index].xaiExpanded =
                            !_messages[index].xaiExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.psychology_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              Tr.t('chat_xai_label'),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Icon(
                            msg.xaiExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (msg.xaiExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (msg.evidenceLevel != null) ...[
                            Row(children: [
                              Text(
                                Tr.t('xai_evidence_label'),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                msg.evidenceLevel!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 6),
                          ],
                          if (msg.sources.isNotEmpty) ...[
                            Text(
                              Tr.t('xai_sources_label'),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...msg.sources.map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(
                                  '• $s',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ] else
                            Text(
                              Tr.t('xai_context_note'),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aiAvatar(),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aiAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              Tr.t('chat_disclaimer'),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _controller,
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                  textInputAction: TextInputAction.send,
                  onSubmitted: _loading ? null : _submitQuery,
                  decoration: InputDecoration(
                    hintText: Tr.t('chat_input_hint'),
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.textDisabled,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _loading ? null : () => _submitQuery(_controller.text),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _loading ? AppColors.textDisabled : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
