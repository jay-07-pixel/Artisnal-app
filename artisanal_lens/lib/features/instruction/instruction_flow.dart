import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../domain/entities/shot_set.dart';
import '../capture/capture_session_controller.dart';

/// Starts the documented instruction sequence for one required photograph.
///
/// Photo list (and empty slots on the product viewer) call this so the
/// session always carries the chosen set, shot type and slot. Style is
/// inserted when the shot type needs a fold (Product, Lifestyle, Saree).
/// Detail and Process skip it and go Lighting → Camera, where the setup
/// instructions play over the live preview.
void beginCaptureForSlot(
  BuildContext context,
  WidgetRef ref, {
  required String setId,
  required ShotSlot slot,
}) {
  ref.read(captureSessionProvider.notifier)
    ..startFor(setId)
    ..chooseShotType(slot.shotType, slotIndex: slot.index);

  if (slot.shotType.skipsStyleStep) {
    context.pushNamed(
      AppRoute.lightingSetup,
      pathParameters: {'setId': setId},
    );
    return;
  }

  context.pushNamed(
    AppRoute.shotAndStyle,
    pathParameters: {'setId': setId},
  );
}

/// Unwinds the instruction + capture stack back to the photo list.
///
/// After "Use Photo" the artisan should see the checklist update, not Home.
/// If the list is not on the stack (e.g. they jumped in from the viewer),
/// Home is restored first so Back from the list still works.
void returnToPhotoList(BuildContext context, String setId) {
  final router = GoRouter.of(context);
  final hasList = router.routerDelegate.currentConfiguration.matches.any(
    (match) => match.matchedLocation.endsWith('/list'),
  );

  if (hasList) {
    rootNavigatorKey.currentState?.popUntil((route) {
      return route.settings.name == AppRoute.photoList || route.isFirst;
    });
    return;
  }

  context.goNamed(AppRoute.home);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    context.pushNamed(
      AppRoute.photoList,
      pathParameters: {'setId': setId},
    );
  });
}
