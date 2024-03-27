import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/delivery/app/ui/helper/pocket_helper.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PocketSizesWidget extends StatelessWidget {
  final Function(int) onSelectPocket;
  final List<PocketSize> pocketSizes;
  final int selectedPocketSizeIndex;
  final int? selectedPocketSizeId;

  const PocketSizesWidget({
    required this.selectedPocketSizeIndex,
    required this.pocketSizes,
    required this.onSelectPocket,
    this.selectedPocketSizeId,
    Key? key,
  }) : super(key: key);

  Color getPocketColor(int index) => pocketDetailColor(selectedPocketSizeIndex == index, isAvailable(index));

  Color getSizeThemeColor(int index) => sizeThemeColor(selectedPocketSizeIndex == index, isAvailable(index));

  bool isAvailable(int index) => (pocketSizes[index].availablePocketsCount ?? 0) != 0 && selectedPocketSizeId != pocketSizes[index].id;

  bool isSelected(int index) => selectedPocketSizeIndex == index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: List.generate(pocketSizes.length, (index) {
          return _pocketSizeItem(index, context);
        }),
      ),
    );
  }

  Widget _pocketSizeItem(int index, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.hideKeyboard();
          onSelectPocket(index);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 14.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: getPocketColor(index),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 22.h,
                      ),
                      Container(
                        width: 80.w,
                        height: 30.h,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: getSizeThemeColor(index)),
                        child: Center(
                          child: Text(
                            "Size ${pocketSizes[index].name[0]}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: isAvailable(index) || !isAvailable(index) ? AppTheme.yellow1 : AppTheme.butterOrange,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "${LocaleKeys.delivery_width.trans()}x${LocaleKeys.delivery_height.trans()}",
                        style: isSelected(index) || !isAvailable(index) ? AppTheme.white_14w400 : AppTheme.black_14w400,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "${pocketSizes[index].width.toString()}x${pocketSizes[index].height.toString()}",
                        style: isSelected(index) || !isAvailable(index) ? AppTheme.white_16w600 : AppTheme.black_16w600,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        LocaleKeys.delivery_available.trans(),
                        style: isSelected(index) || !isAvailable(index) ? AppTheme.white_14w400 : AppTheme.black_14w400,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        pocketSizes[index].availablePocketsCount?.toString() ?? "",
                        style: !isAvailable(index) ? AppTheme.red1_16w600 : (isSelected(index) ? AppTheme.white_16w600 : AppTheme.black_16w600),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  ),
                ),
              ),
              isSelected(index)
                  ? Center(
                      child: Container(
                        height: 27.w,
                        width: 27.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                          color: Colors.white,
                          border: Border.all(color: AppTheme.yellow1, width: 3.w),
                        ),
                        child: Center(
                          child: Assets.icons.icDeliveryCheck.image(),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
