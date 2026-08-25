import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/capture/presentation/capture_page.dart';
import '../features/checklist/presentation/product_setup_page.dart';
import '../features/completion/presentation/completion_page.dart';
import '../features/gallery/presentation/gallery_page.dart';
import '../features/gallery/presentation/product_viewer_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/onboarding/presentation/opening_sequence_page.dart';
import '../features/review/presentation/review_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/shot_type/presentation/shot_and_style_page.dart';
import '../shared/widgets/app_shell.dart';

/// Route names, referenced by screens rather than raw path strings.
abstract final class AppRoute {
  static const String splash = 'splash';
  static const String home = 'home';
  static const String gallery = 'gallery';
  static const String settings = 'settings';
  static const String productSetup = 'productSetup';
  static const String shotAndStyle = 'shotAndStyle';
  static const String capture = 'capture';
  static const String review = 'review';
  static const String completion = 'completion';
  static const String productViewer = 'productViewer';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splash,
        builder: (context, state) => const OpeningSequencePage(),
      ),

      // The three tabs that share the bottom navigation shell.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRoute.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/gallery',
            name: AppRoute.gallery,
            builder: (context, state) => const GalleryPage(),
          ),
          GoRoute(
            path: '/settings',
            name: AppRoute.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),

      // The capture flow runs above the shell so the bottom bar is out of the
      // way once a shoot has started.
      GoRoute(
        path: '/product/setup',
        name: AppRoute.productSetup,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ProductSetupPage(
          setId: state.uri.queryParameters['setId'],
        ),
      ),
      GoRoute(
        path: '/product/:setId/shot',
        name: AppRoute.shotAndStyle,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ShotAndStylePage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/capture',
        name: AppRoute.capture,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => CapturePage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/review',
        name: AppRoute.review,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ReviewPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/complete',
        name: AppRoute.completion,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => CompletionPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/photos',
        name: AppRoute.productViewer,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ProductViewerPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
    ],
  );
}
