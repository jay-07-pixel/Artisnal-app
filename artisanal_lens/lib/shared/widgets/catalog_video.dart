import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimens.dart';
import 'asset_placeholder.dart';

/// Plays a catalog tutorial video when the bundled file exists.
///
/// Missing `.mp4` files stay missing: this never fabricates a clip or
/// substitutes an unrelated video.
class CatalogVideo extends StatefulWidget {
  const CatalogVideo({
    required this.assetPath,
    this.height = 200,
    super.key,
  });

  final String? assetPath;
  final double height;

  @override
  State<CatalogVideo> createState() => _CatalogVideoState();
}

class _CatalogVideoState extends State<CatalogVideo> {
  Future<bool>? _exists;

  @override
  void initState() {
    super.initState();
    _exists = _assetExists(widget.assetPath);
  }

  @override
  void didUpdateWidget(CatalogVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _exists = _assetExists(widget.assetPath);
    }
  }

  static Future<bool> _assetExists(String? path) async {
    if (path == null || path.isEmpty) return false;
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _exists,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return _BundledPlayer(
            assetPath: widget.assetPath!,
            height: widget.height,
          );
        }
        return AssetPlaceholder(
          label: 'Tutorial video to be added',
          icon: Icons.play_circle_outline,
          height: widget.height,
        );
      },
    );
  }
}

class _BundledPlayer extends StatefulWidget {
  const _BundledPlayer({
    required this.assetPath,
    required this.height,
  });

  final String assetPath;
  final double height;

  @override
  State<_BundledPlayer> createState() => _BundledPlayerState();
}

class _BundledPlayerState extends State<_BundledPlayer> {
  VideoPlayerController? _controller;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void didUpdateWidget(_BundledPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _controller?.dispose();
      _controller = null;
      _error = null;
      _open();
    }
  }

  Future<void> _open() async {
    final controller = VideoPlayerController.asset(widget.assetPath);
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (error) {
      await controller.dispose();
      if (!mounted) return;
      setState(() => _error = error);
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
    final controller = _controller;
    if (_error != null || controller == null || !controller.value.isInitialized) {
      return AssetPlaceholder(
        label: 'Tutorial video to be added',
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
            Material(
              color: Colors.transparent,
              child: IconButton(
                iconSize: 56,
                color: AppColors.white,
                onPressed: () {
                  if (value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                icon: Icon(
                  value.isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
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
