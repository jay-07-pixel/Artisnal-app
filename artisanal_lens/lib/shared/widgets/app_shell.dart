import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimens.dart';
import '../../app/theme/app_typography.dart';

/// The bottom navigation shell.
///
/// Four destinations, matching the "Bottom Navigation Shell" component in
/// Figma: Home, Gallery, New Product and Settings. "New Product" is an action
/// rather than a tab — it starts the setup flow above the shell.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _BottomNav(location: _locationOf(context)),
    );
  }

  String _locationOf(BuildContext context) =>
      GoRouterState.of(context).uri.path;
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundAlt,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppDimens.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isActive: location == '/home',
                onTap: () => context.goNamed(AppRoute.home),
              ),
              _NavItem(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                isActive: location == '/gallery',
                onTap: () => context.goNamed(AppRoute.gallery),
              ),
              _NavItem(
                icon: Icons.add_a_photo_outlined,
                label: 'New Product',
                isActive: false,
                onTap: () => context.pushNamed(AppRoute.material),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: location == '/settings',
                onTap: () => context.goNamed(AppRoute.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The active destination is drawn as a filled terracotta pill wrapping
    // both icon and label.
    final foreground =
        isActive ? AppColors.textOnPrimary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16,
              vertical: AppDimens.space8,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 22, color: foreground),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.navLabel.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
