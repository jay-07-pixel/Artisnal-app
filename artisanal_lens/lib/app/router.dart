import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/capture/presentation/capture_page.dart';
import '../features/checklist/presentation/material_selection_page.dart';
import '../features/checklist/presentation/photo_list_page.dart';
import '../features/checklist/presentation/product_setup_page.dart';
import '../features/checklist/presentation/silk_type_page.dart';
import '../features/completion/presentation/completion_page.dart';
import '../features/gallery/presentation/gallery_page.dart';
import '../features/gallery/presentation/product_viewer_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/instruction/presentation/lighting_setup_page.dart';
import '../features/instruction/presentation/tutorial_page.dart';
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
  static const String material = 'material';
  static const String silkType = 'silkType';
  static const String photoList = 'photoList';
  static const String shotAndStyle = 'shotAndStyle';
  static const String lightingSetup = 'lightingSetup';
  static const String tutorial = 'tutorial';
  static const String capture = 'capture';
  static const String review = 'review';
  static const String completion = 'completion';
  static const String productViewer = 'productViewer';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
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
        path: '/product/material',
        name: AppRoute.material,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MaterialSelectionPage(),
      ),
      GoRoute(
        path: '/product/silk-type',
        name: AppRoute.silkType,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => SilkTypePage(
          materialId: state.uri.queryParameters['material'],
        ),
      ),
      GoRoute(
        path: '/product/setup',
        name: AppRoute.productSetup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ProductSetupPage(
          setId: state.uri.queryParameters['setId'],
          materialId: state.uri.queryParameters['material'],
          silkTypeId: state.uri.queryParameters['silkType'],
        ),
      ),
      GoRoute(
        path: '/product/:setId/list',
        name: AppRoute.photoList,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => PhotoListPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/shot',
        name: AppRoute.shotAndStyle,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ShotAndStylePage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/lighting',
        name: AppRoute.lightingSetup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => LightingSetupPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/tutorial',
        name: AppRoute.tutorial,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => TutorialPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      // Alignment is no longer a screen of its own: the grid, the alignment
      // instruction and the live checks all live on the camera.
      GoRoute(
        path: '/product/:setId/capture',
        name: AppRoute.capture,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CapturePage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/review',
        name: AppRoute.review,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ReviewPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/complete',
        name: AppRoute.completion,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CompletionPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
      GoRoute(
        path: '/product/:setId/photos',
        name: AppRoute.productViewer,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ProductViewerPage(
          setId: state.pathParameters['setId']!,
        ),
      ),
    ],
  );
}
