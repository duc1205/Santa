import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/widgets/receive_owner_package_item_from_another_cabinet.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class OwnerPackagesFromAnotherCabinetsWidget extends StatefulWidget {
  final CabinetInfo cabinetInfo;

  const OwnerPackagesFromAnotherCabinetsWidget({super.key, required this.cabinetInfo});

  @override
  State<OwnerPackagesFromAnotherCabinetsWidget> createState() => _OwnerPackagesFromAnotherCabinetWidgetsState();
}

class _OwnerPackagesFromAnotherCabinetWidgetsState extends State<OwnerPackagesFromAnotherCabinetsWidget> {
  final bool isSelected = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(16.sp),
              ),
              color: AppTheme.commercialWhite,
            ),
            child: ListTileTheme(
              dense: false,
              contentPadding: const EdgeInsets.all(0),
              horizontalTitleGap: 0,
              minLeadingWidth: 0,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  trailing: Container(
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16.sp),
                      ),
                    ),
                    child: isExpanded ? Assets.icons.icArrowUp.image() : Assets.icons.icArrowDown.image(),
                  ),
                  title: Container(
                    height: 74.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.sp),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 46.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.sp),
                              bottomRight: Radius.circular(16.sp),
                            ),
                            color: AppTheme.borderLight,
                          ),
                        ),
                        SizedBox(
                          width: 14.h,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cabinetInfo.name,
                              style: AppTheme.black_16w600,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              "• ${widget.cabinetInfo.receivableDeliveries?.length ?? 0} ${LocaleKeys.delivery_package.trans()}",
                              style: AppTheme.neutral_14w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  children: [
                    widget.cabinetInfo.receivableDeliveries != null
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.sp),
                              ),
                              color: AppTheme.commercialWhite,
                            ),
                            child: CustomScrollView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              slivers: [
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      ListView.builder(
                                        padding: EdgeInsets.only(top: 13.h),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) => ReceiveOwnerPackageItemFromAnotherCabinet(
                                          delivery: widget.cabinetInfo.receivableDeliveries![index],
                                        ),
                                        itemCount: widget.cabinetInfo.receivableDeliveries?.length ?? 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
          !isExpanded
              ? Container(
                  height: 5.h,
                  width: 318.w,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.sp),
                      bottomRight: Radius.circular(15.sp),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
