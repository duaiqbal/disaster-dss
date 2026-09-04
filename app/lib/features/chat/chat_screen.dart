// UNVERIFIED DRAFT — not run/tested against a real Flutter build.
// Chat screen: query input -> retrieval -> rules engine -> display with
// source/timestamp/evidence-level transparency (Milestone 6 requirement).

import 'package:flutter/material.dart';
import '../../core/retrieval/retrieval_engine.dart';
import '../../core/rules_engine/rules_engine.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  GuidanceResponse? _response;
  bool _loading = false;

  Future<void> _submitQuery() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);

    final chunks = await RetrievalEngine.search(query);
    final response = RulesEngine.buildResponse(query, chunks, offline: true);

    setState(() {
      _response = response;
      _loading = false;
    });
  }

  String _evidenceLabel(EvidenceLevel level) {
    switch (level) {
      case EvidenceLevel.high:
        return 'High evidence';
      case EvidenceLevel.moderate:
        return 'Moderate evidence';
      case EvidenceLevel.limited:
        return 'Limited evidence';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disaster Guidance')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask in English, Urdu, or Roman Urdu...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitQuery(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _submitQuery,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Ask'),
            ),
            const SizedBox(height: 16),
            if (_response != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_response!.answerText),
                      const SizedBox(height: 8),
                      Chip(label: Text(_evidenceLabel(_response!.evidenceLevel))),
                      if (_response!.staleNote != null)
                        Text(
                          _response!.staleNote!,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.orange),
                        ),
                      const Divider(),
                      const Text('Sources:', style: TextStyle(fontWeight: FontWeight.bold)),
                      for (final s in _response!.sources)
                        Text('- ${s.sourceOrg}: ${s.sourceTitle} (${s.publicationDate})'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
