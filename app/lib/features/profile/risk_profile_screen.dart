import 'package:flutter/material.dart';
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

  Future<void> _save() async {
    setState(() => _saving = true);
    await ApiService.post('/api/profile', {
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
        const SnackBar(
          content: Text('Risk profile saved!'),
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
        title: Text('Risk Profile Setup',
            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set up your risk profile',
                style: AppTextStyles.screenHeader.copyWith(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              'Tell us about your household so we can personalize your risk assessment.',
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 10),
            // Breadcrumb
            Row(
              children: [
                _BreadcrumbStep(label: 'Location', active: true),
                const Icon(Icons.arrow_forward_ios,
                    size: 10, color: AppColors.textMuted),
                _BreadcrumbStep(label: 'Household', active: true),
                const Icon(Icons.arrow_forward_ios,
                    size: 10, color: AppColors.textMuted),
                _BreadcrumbStep(label: 'Done', active: false),
              ],
            ),
            const SizedBox(height: 20),

            // Location section
            _SectionCard(
              title: 'Where is your household located?',
              child: Column(
                children: [
                  _PrimaryBtn(
                    icon: Icons.my_location,
                    label: 'Use current location',
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
                    label: const Text('Select location'),
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
                              Text('SELECTED LOCATION',
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700)),
                              Text('Chitral, Khyber Pakhtunkhwa',
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
              title: 'House construction',
              child: _RadioGroup(
                options: const ['Reinforced', 'Masonry', 'Mud / unreinforced', 'Other'],
                selected: _construction,
                onChanged: (v) => setState(() => _construction = v),
              ),
            ),
            const SizedBox(height: 12),

            // River
            _SectionCard(
              title: 'How close is your home to a river?',
              child: _RadioGroup(
                options: const ['Very close', 'Nearby', 'Far'],
                selected: _riverDistance,
                onChanged: (v) => setState(() => _riverDistance = v),
              ),
            ),
            const SizedBox(height: 12),

            // Slope
            _SectionCard(
              title: 'How close is your home to a steep slope?',
              child: _RadioGroup(
                options: const ['Very close', 'Nearby', 'Far'],
                selected: _slopeDistance,
                onChanged: (v) => setState(() => _slopeDistance = v),
              ),
            ),
            const SizedBox(height: 12),

            // Vulnerable members (multi-select)
            _SectionCard(
              title:
                  'Does your household include anyone who may need additional assistance?',
              subtitle: '(Select all that apply)',
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
                    title: const Text('No'),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  ...[
                    ('Elderly', _elderly, (v) {
                      _elderly = v ?? false;
                      if (_elderly) _noVulnerable = false;
                    }),
                    ('Children', _children, (v) {
                      _children = v ?? false;
                      if (_children) _noVulnerable = false;
                    }),
                    ('Person with disability', _disability, (v) {
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
              title: 'Do you keep livestock?',
              child: Row(
                children: [
                  Expanded(
                    child: _ToggleBtn(
                      label: 'Yes',
                      active: _livestock,
                      onTap: () => setState(() => _livestock = true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToggleBtn(
                      label: 'No',
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
              title: 'How easily can your household access transport?',
              child: _RadioGroup(
                options: const [
                  'Easy vehicle access',
                  'Limited access',
                  'No vehicle access'
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
                    : const Text('Save Risk Profile'),
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
                  Text(
                    'Your household information is used to personalize your risk guidance.',
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted, fontSize: 11),
                    textAlign: TextAlign.center,
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

class _RadioGroup extends StatelessWidget {
  final List<String> options;
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
        final isSelected = opt == selected;
        return GestureDetector(
          onTap: () => onChanged(opt),
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
            child: Text(opt,
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
