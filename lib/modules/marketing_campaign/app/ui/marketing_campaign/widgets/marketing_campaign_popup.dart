import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/remote_image_resize_helper.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';

class MarketingCampaignPopup extends StatelessWidget {
  final Function() onClickPopup;
  final MarketingCampaign marketingCampaign;

  const MarketingCampaignPopup({Key? key, required this.onClickPopup, required this.marketingCampaign, k}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 18.h),
        width: 1.sw,
        height: 1.sh,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 104.h,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Get.back(),
                child: Assets.icons.icCloseRounded.image(
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            InkWell(
              onTap: () => onClickPopup(),
              child: SizedBox(
                height: 411.h,
                width: 307.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: CachedNetworkImage(
                    imageUrl: RemoteImageResizeHelper.getImageResize(
                      marketingCampaign.popupUrl ?? "",
                      307.w * MediaQuery.of(context).devicePixelRatio,
                      411.h * MediaQuery.of(context).devicePixelRatio,
                    ),
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                    fit: BoxFit.fill,
                    fadeInDuration: const Duration(milliseconds: 800),
                    fadeInCurve: Curves.easeInQuad,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
