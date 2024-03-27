import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:santapocket/helpers/remote_image_resize_helper.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({required this.index, required this.sources, Key? key}) : super(key: key);

  final int index;
  final List<String> sources;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 24.sp,
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: PhotoViewGallery.builder(
          itemCount: widget.sources.length,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                RemoteImageResizeHelper.getImageResize(
                  widget.sources[index],
                  375.w * MediaQuery.of(context).devicePixelRatio, //convert dp to pixel by multiple dp to device Pixel ratio
                  869.h * MediaQuery.of(context).devicePixelRatio,
                ),
              ),
              minScale: PhotoViewComputedScale.contained * 0.95,
              initialScale: PhotoViewComputedScale.contained * 0.95,
              maxScale: PhotoViewComputedScale.contained * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          pageController: _pageController,
        ),
      ),
    );
  }
}
