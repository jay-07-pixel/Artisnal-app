import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/user_profile_controller.dart';

/// Lets the artisan enter their name — stored locally on this device.
class ProfileSettingsSection extends ConsumerStatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  ConsumerState<ProfileSettingsSection> createState() =>
      _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState extends ConsumerState<ProfileSettingsSection> {
  final _nameController = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(userProfileProvider);

    if (!_editing && name != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoCard(
            icon: Icons.person_outline,
            title: 'Your name',
            body: name,
          ),
          const SizedBox(height: AppDimens.space12),
          OutlinedButton(
            onPressed: () {
              _nameController.text = name;
              setState(() => _editing = true);
            },
            child: const Text('Change name'),
          ),
        ],
      );
    }

    if (!_editing && name == null) {
      _nameController.text = '';
    } else if (_editing && _nameController.text.isEmpty && name != null) {
      _nameController.text = name;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _saveName(),
          decoration: const InputDecoration(
            labelText: 'Your name',
            hintText: 'e.g. Priya, Ramesh',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppDimens.space16),
        FilledButton(
          onPressed: _saveName,
          child: Text(name == null ? 'Save' : 'Update'),
        ),
        if (name != null) ...[
          const SizedBox(height: AppDimens.space8),
          TextButton(
            onPressed: () => setState(() => _editing = false),
            child: const Text('Cancel'),
          ),
        ],
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLargeBold),
                const SizedBox(height: 2),
                Text(body, style: AppTypography.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveName() async {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Enter your name.')),
        );
      return;
    }

    await ref.read(userProfileProvider.notifier).setName(name);
    if (!mounted) return;
    setState(() => _editing = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Saved as $name.')));
  }
}
