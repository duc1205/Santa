import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/string_helper.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/cabinet_detail_page.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CabinetItem extends StatelessWidget {
  const CabinetItem({
    required this.cabinet,
    required this.distance,
    Key? key,
  }) : super(key: key);

  final Cabinet cabinet;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.linghDarkPink,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => CabinetDetailPage(cabinetId: cabinet.id));
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                width: 40.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppTheme.red,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Assets.icons.icCabinetLocationWhite.image(
                      width: 15.w,
                      height: 18.h,
                    ),
                    Text(
                      distance != null && distance! >= 10.0 ? ">10 km" : FormatHelper.formatDistance(distance),
                      style: AppTheme.white_12,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cabinet.name,
                      style: AppTheme.black_16w600,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Visibility(
                      visible: !StringHelper.isNullOrEmpty(cabinet.location?.address),
                      child: Text(
                        cabinet.location?.address ?? '',
                        style: AppTheme.blackDark_14,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
