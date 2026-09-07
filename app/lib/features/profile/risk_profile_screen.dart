import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/app_translations.dart';
import '../../core/localization/language_service.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RiskProfileScreen extends StatefulWidget {
  const RiskProfileScreen({super.key});
  @override
  State<RiskProfileScreen> createState() => _RiskProfileScreenState();
}

class _RiskProfileScreenState extends State<RiskProfileScreen> {
  String _construction = 'Reinforced';
  String _riverDistance = 'Nearby';
  String _slopeDistance = 'Far';
  bool _elderly = true;
  bool _children = true;
  bool _disability = false;
  bool _noVulnerable = false;
  bool _livestock = true;
  String _transport = 'Easy vehicle access';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _construction = prefs.getString('rp_construction') ?? _construction;
      _riverDistance = prefs.getString('rp_river') ?? _riverDistance;
      _slopeDistance = prefs.getString('rp_slope') ?? _slopeDistance;
      _elderly = prefs.getBool('rp_elderly') ?? _elderly;
      _children = prefs.getBool('rp_children') ?? _children;
      _disability = prefs.getBool('rp_disability') ?? _disability;
      _livestock = prefs.getBool('rp_livestock') ?? _livestock;
      _transport = prefs.getString('rp_transport') ?? _transport;
      _noVulnerable = !_elderly && !_children && !_disability;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rp_construction', _construction);
    await prefs.setString('rp_river', _riverDistance);
    await prefs.setString('rp_slope', _slopeDistance);
    await prefs.setBool('rp_elderly', _elderly);
    await prefs.setBool('rp_children', _children);
    await prefs.setBool('rp_disability', _disability);
    await prefs.setBool('rp_livestock', _livestock);
    await prefs.setString('rp_transport', _transport);

    // Fire-and-forget sync to backend
    ApiService.post('/api/profile', {
      'construction': _construction,
      'river_distance': _riverDistance,
      'slope_distance': _slopeDistance,
      'vulnerable_members': {
        'elderly': _elderly,
        'children': _children,
        'disability': _disability,
      },
      'livestock': _livestock,
      'transport': _transport,
    });

    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Tr.t('risk_profile_saved_local')),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(Tr.t('risk_setup_appbar'),
            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Tr.t('risk_setup_title'),
                style: AppTextStyles.screenHeader.copyWith(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              Tr.t('risk_setup_subtitle'),
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 10),
            // Breadcrumb
            Row(
              children: [
                _BreadcrumbStep(label: Tr.t('step_location'), active: true),
                const Icon(Icons.arrow_forward_ios,
                    size: 10, color: AppColors.textMuted),
                _BreadcrumbStep(label: Tr.t('step_household'), active: true),
                const Icon(Icons.arrow_forward_ios,
                    size: 10, color: AppColors.textMuted),
                _BreadcrumbStep(label: Tr.t('step_done'), active: false),
              ],
            ),
            const SizedBox(height: 20),

            // Location section
            _SectionCard(
              title: Tr.t('loc_section_title'),
              child: Column(
                children: [
                  _PrimaryBtn(
                    icon: Icons.my_location,
                    label: Tr.t('btn_current_loc'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.map_outlined, size: 16),
                    label: Text(Tr.t('btn_select_loc')),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Tr.t('lbl_selected_loc'),
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700)),
                              Text(Tr.t('location_chitral'),
                                  style: AppTextStyles.body.copyWith(
                                      color: AppColors.primary, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Construction
            _SectionCard(
              title: Tr.t('house_const_title'),
              child: _RadioGroup(
                options: [
                  _OptionItem('Reinforced', Tr.t('const_reinforced')),
                  _OptionItem('Masonry', Tr.t('const_masonry')),
                  _OptionItem('Mud / unreinforced', Tr.t('const_mud')),
                  _OptionItem('Other', Tr.t('const_other')),
                ],
                selected: _construction,
                onChanged: (v) => setState(() => _construction = v),
              ),
            ),
            const SizedBox(height: 12),

            // River
            _SectionCard(
              title: Tr.t('river_dist_title'),
              child: _RadioGroup(
                options: [
                  _OptionItem('Very close', Tr.t('dist_very_close')),
                  _OptionItem('Nearby', Tr.t('dist_nearby')),
                  _OptionItem('Far', Tr.t('dist_far')),
                ],
                selected: _riverDistance,
                onChanged: (v) => setState(() => _riverDistance = v),
              ),
            ),
            const SizedBox(height: 12),

            // Slope
            _SectionCard(
              title: Tr.t('slope_dist_title'),
              child: _RadioGroup(
                options: [
                  _OptionItem('Very close', Tr.t('dist_very_close')),
                  _OptionItem('Nearby', Tr.t('dist_nearby')),
                  _OptionItem('Far', Tr.t('dist_far')),
                ],
                selected: _slopeDistance,
                onChanged: (v) => setState(() => _slopeDistance = v),
              ),
            ),
            const SizedBox(height: 12),

            // Vulnerable members (multi-select)
            _SectionCard(
              title: Tr.t('vuln_title'),
              subtitle: Tr.t('vuln_subtitle'),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: _noVulnerable,
                    onChanged: (v) => setState(() {
                      _noVulnerable = v ?? false;
                      if (_noVulnerable) {
                        _elderly = false;
                        _children = false;
                        _disability = false;
                      }
                    }),
                    title: Text(Tr.t('vuln_none')),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  ...[
                    (Tr.t('vuln_elderly'), _elderly, (v) {
                      _elderly = v ?? false;
                      if (_elderly) _noVulnerable = false;
                    }),
                    (Tr.t('vuln_children'), _children, (v) {
                      _children = v ?? false;
                      if (_children) _noVulnerable = false;
                    }),
                    (Tr.t('vuln_disability'), _disability, (v) {
                      _disability = v ?? false;
                      if (_disability) _noVulnerable = false;
                    }),
                  ].map((entry) {
                    final label = entry.$1;
                    final checked = entry.$2;
                    final onChanged = entry.$3 as void Function(bool?);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: checked ? AppColors.primaryContainer : null,
                        borderRadius: BorderRadius.circular(8),
                        border: checked
                            ? Border.all(color: AppColors.primary)
                            : null,
                      ),
                      child: CheckboxListTile(
                        value: checked,
                        onChanged: (v) => setState(() => onChanged(v)),
                        title: Text(label),
                        activeColor: AppColors.primary,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Livestock
            _SectionCard(
              title: Tr.t('livestock_title'),
              child: Row(
                children: [
                  Expanded(
                    child: _ToggleBtn(
                      label: LanguageService.instance.isUrdu ? 'ہاں' : 'Yes',
                      active: _livestock,
                      onTap: () => setState(() => _livestock = true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToggleBtn(
                      label: LanguageService.instance.isUrdu ? 'نہیں' : 'No',
                      active: !_livestock,
                      onTap: () => setState(() => _livestock = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Transport
            _SectionCard(
              title: Tr.t('transport_title'),
              child: _RadioGroup(
                options: [
                  _OptionItem('Easy vehicle access', Tr.t('trans_easy')),
                  _OptionItem('Limited access', Tr.t('trans_limited')),
                  _OptionItem('No vehicle access', Tr.t('trans_none')),
                ],
                selected: _transport,
                onChanged: (v) => setState(() => _transport = v),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(Tr.t('save_risk_profile')),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      Tr.t('risk_profile_privacy_note'),
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _BreadcrumbStep extends StatelessWidget {
  final String label;
  final bool active;
  const _BreadcrumbStep({required this.label, required this.active});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(label,
          style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.textMuted,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  const _SectionCard({required this.title, this.subtitle, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!,
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _OptionItem {
  final String key;
  final String label;
  const _OptionItem(this.key, this.label);
}

class _RadioGroup extends StatelessWidget {
  final List<_OptionItem> options;
  final String selected;
  final ValueChanged<String> onChanged;
  const _RadioGroup({
    required this.options,
    required this.selected,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final isSelected = opt.key == selected;
        return GestureDetector(
          onTap: () => onChanged(opt.key),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryContainer : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(opt.label,
                style: AppTextStyles.body.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14)),
          ),
        );
      }).toList(),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PrimaryBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, size: 16),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleBtn({required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(label,
              style: AppTextStyles.body.copyWith(
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
        ),
      ),
    );
  }
}
