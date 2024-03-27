import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/helpers/remote_image_resize_helper.dart';

class CabinetGalleryItemView extends StatelessWidget {
  final String linkImage;
  final VoidCallback onItemClick;

  const CabinetGalleryItemView({required this.linkImage, required this.onItemClick, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        20.r,
      ),
      child: GestureDetector(
        onTap: onItemClick,
        child: Image.network(
          RemoteImageResizeHelper.getImageResize(
            linkImage,
            150.w * MediaQuery.of(context).devicePixelRatio,
            130.h * MediaQuery.of(context).devicePixelRatio,
          ),
          errorBuilder: (context, exception, stackTrace) => SizedBox(
            width: 150.w,
            height: 130.h,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
