import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../conditional/conditional.dart';
import '../models/preview_image.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    super.key,
    this.imageHeaders,
    required this.images,
    required this.onClosePressed,
    required this.onDownloadPressed,
    this.options = const ImageGalleryOptions(),
    required this.pageController,
  });

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Images to show in the gallery.
  final List<PreviewImage> images;

  /// Triggered when the gallery is swiped down or closed via the icon.
  final VoidCallback onClosePressed;

  final Function(String) onDownloadPressed;

  /// Customisation options for the gallery.
  final ImageGalleryOptions options;

  /// Page controller for the image pages.
  final PageController pageController;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              builder: (BuildContext context, int index) => PhotoViewGalleryPageOptions(
                imageProvider: Conditional().getProvider(
                  images[index].uri,
                  headers: imageHeaders,
                ),
                minScale: options.minScale,
                maxScale: options.maxScale,
              ),
              itemCount: images.length,
              loadingBuilder: (context, event) => _imageGalleryLoadingBuilder(event),
              pageController: pageController,
              scrollPhysics: const ClampingScrollPhysics(),
            ),
            Positioned.directional(
              end: 20,
              textDirection: Directionality.of(context),
              top: 56,
              child: CloseButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  onClosePressed();
                },
              ),
            ),
            Positioned.directional(
              end: 20,
              textDirection: Directionality.of(context),
              bottom: 40,
              child: IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  onDownloadPressed(images[pageController.page?.toInt() ?? 0].uri);
                },
              ),
            ),
          ],
        ),
      );

  Widget _imageGalleryLoadingBuilder(ImageChunkEvent? event) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: event == null || event.expectedTotalBytes == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      );
}

class ImageGalleryOptions {
  const ImageGalleryOptions({
    this.maxScale,
    this.minScale,
  });

  /// See [PhotoViewGalleryPageOptions.maxScale].
  final dynamic maxScale;

  /// See [PhotoViewGalleryPageOptions.minScale].
  final dynamic minScale;
}
