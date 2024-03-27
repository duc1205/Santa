import 'package:badges/badges.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/receive_owner_packages_page_viewmodel.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/widgets/empty_receive_owner_package_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/widgets/owner_packages_from_another_cabinets_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/widgets/receive_owner_package_item.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ReceiveOwnerPackagesPage extends StatefulWidget {
  final List<Delivery> deliveries;
  final List<DeliveryAuthorization> deliveryAuthorizations;
  final List<CabinetInfo> listCabinetWithDeliveries;
  final CabinetInfo cabinetInfo;
  final Map<String, dynamic>? bankTransferInfo;
  final User? user;
  final bool isFirstLoading;
  final void Function(int) onSelectedTab;
  final TabController tabController;

  const ReceiveOwnerPackagesPage({
    Key? key,
    required this.deliveries,
    required this.deliveryAuthorizations,
    required this.listCabinetWithDeliveries,
    required this.cabinetInfo,
    required this.bankTransferInfo,
    required this.user,
    required this.isFirstLoading,
    required this.onSelectedTab,
    required this.tabController,
  }) : super(key: key);

  @override
  State<ReceiveOwnerPackagesPage> createState() => _ReceiveOwnerPackagesPageState();
}

class _ReceiveOwnerPackagesPageState extends BaseViewState<ReceiveOwnerPackagesPage, ReceiveOwnerPackagesPageViewModel> {
  @override
  ReceiveOwnerPackagesPageViewModel createViewModel() => locator<ReceiveOwnerPackagesPageViewModel>();

  @override
  void loadArguments() {
    viewModel.loadArguments(
      widget.cabinetInfo,
      widget.deliveries,
      widget.listCabinetWithDeliveries,
      widget.user,
      widget.bankTransferInfo,
    );
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.isFirstLoading,
      child: viewModel.listCabinetWithDeliveries.isNotEmpty
          ? Column(
              children: [
                const DeliveryStepsWidget(
                  step: 1,
                  isReceiving: true,
                ),
                TabBar(
                  controller: widget.tabController,
                  onTap: widget.onSelectedTab,
                  unselectedLabelColor: AppTheme.grey,
                  indicatorColor: AppTheme.orange,
                  labelColor: AppTheme.orange,
                  labelStyle: AppTheme.yellow1_14w600,
                  tabs: [
                    Tab(
                      icon: Badge(
                        position: BadgePosition.topEnd(top: -12, end: -18),
                        badgeColor: AppTheme.red,
                        elevation: 0,
                        badgeContent: Text(
                          viewModel.deliveries.length.toString(),
                          style: AppTheme.white_14w600,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        borderRadius: BorderRadius.circular(10.r),
                        animationType: BadgeAnimationType.fade,
                        child: Text(LocaleKeys.delivery_packages.trans()),
                      ),
                    ),
                    Tab(
                      icon: Badge(
                        position: BadgePosition.topEnd(top: -12, end: -18),
                        badgeColor: AppTheme.red,
                        animationType: BadgeAnimationType.fade,
                        elevation: 0,
                        badgeContent: Text(
                          widget.deliveryAuthorizations.length.toString(),
                          style: AppTheme.white_14w600,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Text(LocaleKeys.delivery_authorized.trans()),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            viewModel.deliveries.isNotEmpty
                                ? Obx(
                                    () => Padding(
                                      padding: EdgeInsets.all(15.sp),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16.sp),
                                          ),
                                          color: AppTheme.radiantGlow,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 14.h,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 8.w,
                                                  height: 46.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(16.sp),
                                                      bottomRight: Radius.circular(16.sp),
                                                    ),
                                                    color: AppTheme.gluttonyOrange,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 14.h,
                                                ),
                                                Column(
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
                                                      "• ${viewModel.deliveries.length} ${LocaleKeys.delivery_package.trans()}",
                                                      style: AppTheme.hotOrange_14w400,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            ListView.builder(
                                              padding: EdgeInsets.only(top: 13.h),
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) => Obx(
                                                () => ReceiveOwnerPackageItem(
                                                  delivery: viewModel.deliveries[index],
                                                  onItemClick: () => viewModel.onItemClick(viewModel.deliveries[index]),
                                                  selected: viewModel.deliveries[index].id == viewModel.selectedDelivery?.id,
                                                ),
                                              ),
                                              itemCount: viewModel.deliveries.length,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(bottom: 14.h),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.w),
                                      color: AppTheme.butterOrange,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: EasyRichText(
                                              LocaleKeys.delivery_no_package.trans(namedArgs: {
                                                "userPhoneNumber": viewModel.user?.phoneNumber ?? "",
                                                "cabinetName": viewModel.cabinetInfo.name,
                                              }),
                                              defaultStyle: AppTheme.black_14,
                                              patternList: [
                                                EasyRichTextPattern(
                                                  targetString: LocaleKeys.delivery_have_no.trans().toLowerCase(),
                                                  style: AppTheme.black_14,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () => callHotLine(viewModel.bankTransferInfo?["contacts"]["call"]["value"]),
                                                child: Container(
                                                  width: 160.w,
                                                  height: 58.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(8.sp),
                                                    ),
                                                    color: AppTheme.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Assets.icons.icPhone.image(width: 25.w, height: 25.h),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        "Hotline",
                                                        style: AppTheme.goldishOrange_14w600,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 14.w,
                                              ),
                                              GestureDetector(
                                                onTap: () => launchUri("http://zalo.me/${viewModel.bankTransferInfo?["contacts"]["zalo"]["value"]}"),
                                                child: Container(
                                                  width: 160.w,
                                                  height: 58.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(8.sp),
                                                    ),
                                                    color: AppTheme.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Assets.icons.icHomeZalo.image(width: 25.w, height: 25.h),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        LocaleKeys.delivery_chat_zalo.trans(),
                                                        style: AppTheme.goldishOrange_14w600,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            !viewModel.checkIsCabinetFromSameList()
                                ? Padding(
                                    padding: EdgeInsets.only(left: 15.w),
                                    child: Text(
                                      LocaleKeys.delivery_receiving_list_attention_message.trans(),
                                      style: AppTheme.red_14w400,
                                    ),
                                  )
                                : Container(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.listCabinetWithDeliveries.length,
                              itemBuilder: (context, index) => widget.cabinetInfo.id != viewModel.listCabinetWithDeliveries[index].id
                                  ? OwnerPackagesFromAnotherCabinetsWidget(cabinetInfo: viewModel.listCabinetWithDeliveries[index])
                                  : Container(),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Visibility(
                    visible: viewModel.deliveries.isNotEmpty,
                    child: Container(
                      height: 50.h,
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                      child: SizedBox.expand(
                        child: TapDebouncer(
                          onTap: () async => viewModel.receiveDelivery(),
                          builder: (context, onTap) {
                            return ElevatedButton(
                              onPressed: onTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.delivery_receive.trans(),
                                  style: AppTheme.white_16w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.only(top: 67.h, bottom: 20.h),
              child: EmptyReceiveOwnerPackageWidget(
                cabinetInfo: viewModel.cabinetInfo,
                sendEmail: viewModel.sendEmail,
                bankTransferInfo: viewModel.bankTransferInfo,
                userPhoneNumber: viewModel.user?.phoneNumber ?? "",
              ),
            ),
    );
  }
}
