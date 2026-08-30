import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/auth_controller.dart';
import '../../../app/supabase_config.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/services/auth_service.dart';
import '../../../domain/entities/shot_set.dart';
import '../../../l10n/app_copy.dart';
import '../../home/shot_sets_controller.dart';

/// Sign up, sign in, progress summary, and cloud backup for the artisan account.
class AccountSettingsSection extends ConsumerStatefulWidget {
  const AccountSettingsSection({super.key});

  @override
  ConsumerState<AccountSettingsSection> createState() =>
      _AccountSettingsSectionState();
}

class _AccountSettingsSectionState extends ConsumerState<AccountSettingsSection> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCreateAccount = true;
  bool _busy = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!SupabaseConfig.isConfigured) {
      return _infoCard(
        icon: Icons.cloud_off_outlined,
        title: l10n.cloudBackupNotConfigured,
        body: l10n.cloudBackupNotConfiguredBody,
      );
    }

    final session = ref.watch(authControllerProvider);
    final sets = ref.watch(shotSetsProvider).valueOrNull ?? const <ShotSet>[];

    if (session.isSignedIn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoCard(
            icon: Icons.person_outline,
            title: l10n.signedInAs,
            body: session.username ?? l10n.artisanFallback,
          ),
          const SizedBox(height: AppDimens.space12),
          _ProgressCard(sets: sets),
          const SizedBox(height: AppDimens.space12),
          OutlinedButton.icon(
            onPressed: _busy ? null : _syncNow,
            icon: _busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_sync_outlined, size: 18),
            label: Text(l10n.syncNow),
          ),
          const SizedBox(height: AppDimens.space8),
          TextButton(
            onPressed: _busy ? null : _signOut,
            child: Text(l10n.signOut),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _isCreateAccount ? l10n.createAccountPrompt : l10n.signInPrompt,
          style: AppTypography.labelSmall,
        ),
        const SizedBox(height: AppDimens.space12),
        TextField(
          controller: _usernameController,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l10n.username,
            hintText: l10n.usernameHint,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppDimens.space12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: l10n.password,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppDimens.space16),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(_isCreateAccount ? l10n.createAccount : l10n.signIn),
        ),
        const SizedBox(height: AppDimens.space8),
        TextButton(
          onPressed: _busy
              ? null
              : () => setState(() => _isCreateAccount = !_isCreateAccount),
          child: Text(
            _isCreateAccount ? l10n.alreadyHaveAccount : l10n.needAccount,
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final normalized = AuthService.normalizeUsername(username);
    if (normalized.length < 3) {
      _snack(l10n.usernameTooShort);
      return;
    }
    if (normalized.length > 32) {
      _snack(l10n.usernameTooLong);
      return;
    }
    if (password.length < 6) {
      _snack(l10n.passwordTooShort);
      return;
    }

    setState(() => _busy = true);
    try {
      final auth = ref.read(authControllerProvider.notifier);
      if (_isCreateAccount) {
        await auth.signUp(username: username, password: password);
        _snack(l10n.accountCreated);
      } else {
        await auth.signIn(username: username, password: password);
        _snack(l10n.signedInSuccess);
      }
      _passwordController.clear();
    } on AuthException catch (error) {
      _snack(AppCopy.authError(l10n, error.message));
    } catch (error) {
      _snack(AppCopy.authError(l10n, '$error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(authControllerProvider.notifier).signOut();
      _snack(l10n.signedOutSuccess);
    } catch (error) {
      _snack('$error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _syncNow() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final result =
          await ref.read(authControllerProvider.notifier).syncNow();
      if (result.offline) {
        _snack(l10n.syncOffline);
      } else if (result.didWork) {
        _snack(l10n.syncDone(result.uploadedSets, result.uploadedShots));
      } else {
        _snack(l10n.syncUpToDate);
      }
    } catch (error) {
      _snack(l10n.syncFailed('$error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.sets});

  final List<ShotSet> sets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalProducts = sets.length;
    final finished = sets.where((set) => set.isFinished).length;
    final inProgress =
        sets.where((set) => !set.isFinished && set.completedCount > 0).length;
    final totalPhotos = sets.fold<int>(0, (sum, set) => sum + set.shots.length);

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSelected,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.yourProgress, style: AppTypography.labelLargeBold),
          const SizedBox(height: AppDimens.space8),
          _statRow(l10n.productsStarted, '$totalProducts'),
          _statRow(l10n.finishedSets, '$finished'),
          _statRow(l10n.inProgressSets, '$inProgress'),
          _statRow(l10n.photosCaptured, '$totalPhotos'),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelSmall),
          Text(
            value,
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
