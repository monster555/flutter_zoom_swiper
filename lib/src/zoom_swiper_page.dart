import 'package:flutter/material.dart';
import 'package:flutter_zoom_swiper/src/zoom_swiper.dart';

/// A page that displays a zoomable swiper of images or other content.
///
/// This widget allows users to zoom and swipe through a list of images or other content with ease.
/// It uses the [ZoomSwiper] widget to create a zoomable swiper. The [images] parameter should be
/// a list of image URLs to display in the swiper. The [viewPortFraction] parameter controls
/// the size of the images in the swiper, and the [padding] parameter allows you to add padding
/// around the swiper.
class ZoomSwiperPage extends StatelessWidget {
  /// Creates a [ZoomSwiperPage].
  const ZoomSwiperPage({super.key});

  /// List of image URLs to display in the slider.
  static const images = <String>[
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Swiper'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                  'Zoom and swipe through images or other content with ease.'),
            ),
            // The following examples show how to use the ZoomSwiper widget with different
            // zoom modes.
            SizedBox(
              height: 350,
              child: ZoomSwiper(
                // List of image URLs to display
                images: images,
                // Images will zoom out when swiped
                zoomMode: ZoomMode.zoomOut,
                // Fraction of the viewport for each image
                viewPortFraction: 0.85,
              ),
            ),
            SizedBox(
              height: 350,
              child: ZoomSwiper(
                // List of image URLs to display
                images: images,
                // Images will zoom in when swiped
                zoomMode: ZoomMode.zoomIn,
                // Fraction of the viewport for each image
                viewPortFraction: 0.85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
