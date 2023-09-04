import 'package:flutter/material.dart';
import 'package:flutter_zoom_swiper/src/drag_scroll_behavior_configuration.dart';

/// Enumerates the zoom modes used for swiping animations in the [ZoomSwiper] widget.
///
/// - [ZoomMode.zoomIn] In this mode, the image is displayed at its original size
///   in the upcoming slide and gradually zooms in as the animation progresses.
///
/// - [ZoomMode.zoomOut] In this mode, the image is slightly scaled up in the upcoming
///   slide, and the animation zooms out to its original size over the course of the transition.
enum ZoomMode {
  /// Zoom out mode where images are scaled to fit the viewport.
  zoomOut,

  /// Zoom in mode where images can be zoomed in for a closer view.
  zoomIn;

  /// Helper getters to check the current zoom mode.
  ///
  /// Determines if the current zoom mode is set to [zoomOut].
  bool get isZoomOut => this == ZoomMode.zoomOut;

  /// Determines if the current zoom mode is set to [zoomIn].
  bool get isZoomIn => this == ZoomMode.zoomIn;
}

/// A widget that displays a swiper (slider) with zooming capabilities for images.
///
/// The [ZoomSwiper] widget is designed to display a series of images in a swiper
/// with support for zooming in on individual images. You can customize its
/// behavior by specifying the list of image URLs to display, the zoom mode, and
/// more.
///
/// Example:
///
/// ```dart
/// ZoomSwiper(
///   images: [
///     'image_url_1.jpg',
///     'image_url_2.jpg',
///     'image_url_3.jpg',
///   ],
///   zoomMode: ZoomMode.zoomIn,
///   dragToScroll: true,
///   viewPortFraction: 0.85,
///   padding: EdgeInsets.all(16.0),
/// )
/// ```
///
/// See also:
///
/// - [ZoomMode], which defines different zooming modes for the images.
class ZoomSwiper extends StatefulWidget {
  const ZoomSwiper({
    super.key,
    required this.images,
    this.zoomMode = ZoomMode.zoomOut,
    this.dragToScroll = true,
    this.viewPortFraction = 1,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// List of image URLs to display in the slider.
  final List<String> images;

  /// The zoom mode to use for the slider.
  final ZoomMode zoomMode;

  /// Whether to enable drag to scroll.
  final bool dragToScroll;

  /// The fraction of the viewport that each page should occupy.
  final double viewPortFraction;

  /// The padding to apply around the swiper.
  final EdgeInsets padding;

  @override
  State<ZoomSwiper> createState() => _ZoomSwiperState();
}

/// The state class for the [ZoomSwiper] widget.
///
/// This state class manages the [PageController] for the swiper and keeps
/// track of the index of the current page.
class _ZoomSwiperState extends State<ZoomSwiper> {
  /// The controller for the [PageView].
  late final PageController controller;

  /// The raw index of the current page in the [PageView].
  double pageIndex = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize the [PageController].
    controller = PageController(
      viewportFraction: widget.viewPortFraction,
    );

    // Listen to page changes in the [PageView] controller and update the [pageIndex] accordingly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(() {
        setState(() => pageIndex = controller.page!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior:
          widget.dragToScroll ? DragScrollBehavior() : const ScrollBehavior(),
      child: PageView.builder(
        controller: controller,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          // Calculate the value and scale for the current item in the [PageView].
          double value =
              controller.position.haveDimensions ? pageIndex - index : 0;

          // Apply a scaling factor to the image based on the calculated value.
          double scale = widget.zoomMode.isZoomOut
              ? 1.0 + (value.abs() * 0.3)
              : (1.0 - (value.abs() * 0.3)).clamp(0.8, 1.0);

          return _SwiperItem(
            image: widget.images[index],
            scale: scale,
            zoomMode: widget.zoomMode,
            padding: widget.padding,
          );
        },
      ),
    );
  }
}

/// A widget representing an individual item in the [ZoomSwiper].
///
/// This widget displays an image with optional zooming based on the [zoomMode].
///
/// The [image] parameter is required and specifies the path to the image asset.
/// The [scale] parameter determines the initial scale of the image.
/// The [zoomMode] parameter defines whether the image should allow zooming.
/// The [padding] parameter specifies the padding around the image.
class _SwiperItem extends StatelessWidget {
  /// Creates a [_SwiperItem].
  ///
  /// The [image] parameter is required and represents the URL of the image to be displayed.
  /// The [scale] parameter is required and represents the scaling factor for the image.
  const _SwiperItem({
    required this.image,
    required this.scale,
    required this.zoomMode,
    required this.padding,
  });

  /// The path to the image asset to display.
  final String image;

  /// The initial scale of the image.
  final double scale;

  /// The zoom mode for the image, which determines if zooming is allowed.
  final ZoomMode zoomMode;

  /// The padding around the image.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen.
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        // Apply the given [padding] to the container.
        padding: padding,
        // For demos purposes, the width of the container is clamped between 200 and 500.
        width: width.clamp(200, 500),
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          // Apply a transformation to scale the image based on the given [scale].
          child: Transform.scale(
            // Apply an additional scaling factor of 1.3 for visual effect.
            scale: scale * (zoomMode.isZoomIn ? 1.3 : 1.0),
            child: Image.asset(
              image,
              // Ensure the image fits the height of the container.
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
