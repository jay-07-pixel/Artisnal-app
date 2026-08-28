import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimens.dart';
import '../../data/services/tutorial_video_service.dart';
import '../../l10n/app_localizations.dart';
import 'asset_placeholder.dart';

/// Streams a catalog tutorial video from Supabase Storage when configured.
///
/// Videos are not bundled in the APK. After the first successful stream the
/// file is cached on-device for faster replays.
class CatalogVideo extends StatefulWidget {
  const CatalogVideo({
    required this.videoKey,
    this.height = 200,
    super.key,
  });

  /// Storage object name, e.g. `cushion_propped.mp4`.
  final String? videoKey;
  final double height;

  @override
  State<CatalogVideo> createState() => _CatalogVideoState();
}

class _CatalogVideoState extends State<CatalogVideo> {
  final _videoService = TutorialVideoService();
  VideoPlayerController? _controller;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void didUpdateWidget(CatalogVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoKey != widget.videoKey) {
      _controller?.dispose();
      _controller = null;
      _error = null;
      _loading = true;
      _open();
    }
  }

  Future<void> _open() async {
    final key = widget.videoKey;
    if (key == null || key.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = StateError('missing key');
      });
      return;
    }

    final url = _videoService.publicUrlForKey(key);
    if (url == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = StateError('cloud not configured');
      });
      return;
    }

    final cached = await _videoService.cachedFile(key);
    final controller = cached != null
        ? VideoPlayerController.file(cached)
        : VideoPlayerController.networkUrl(url);

    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
      });
      if (cached == null) {
        // Best-effort cache; playback already works from the stream.
        _videoService.cacheFromUrl(key, url);
      }
    } catch (error) {
      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _openFullscreen() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FullscreenTutorial(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final controller = _controller;
    if (_error != null || controller == null || !controller.value.isInitialized) {
      return AssetPlaceholder(
        label: AppLocalizations.of(context).tutorialVideoPlaceholder,
        icon: Icons.play_circle_outline,
        height: widget.height,
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: ColoredBox(
              color: AppColors.textPrimary,
              child: _Playback(controller: controller),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.space8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _openFullscreen,
            icon: const Icon(Icons.fullscreen, size: 18),
            label: const Text('Full screen'),
          ),
        ),
      ],
    );
  }
}

class _Playback extends StatelessWidget {
  const _Playback({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                child: value.isPlaying
                    ? const SizedBox.expand()
                    : ColoredBox(
                        color: Colors.black26,
                        child: Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 56,
                            color: AppColors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FullscreenTutorial extends StatelessWidget {
  const _FullscreenTutorial({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimary,
        foregroundColor: AppColors.white,
        title: const Text('Tutorial'),
      ),
      body: Center(child: _Playback(controller: controller)),
    );
  }
}
