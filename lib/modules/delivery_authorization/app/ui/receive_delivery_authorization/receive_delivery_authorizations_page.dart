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
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorizations_page_viewmodel.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/widgets/authorized_packages_from_another_cabinets_widget.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/widgets/empty_receive_delivery_authorization_widget.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/widgets/receive_delivery_authorization_item.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ReceiveDeliveryAuthorizationsPage extends StatefulWidget {
  final List<Delivery> deliveries;
  final List<DeliveryAuthorization> deliveryAuthorizations;
  final CabinetInfo cabinetInfo;
  final List<CabinetInfo> listCabinetWithDeliveries;
  final Map<String, dynamic>? bankTransferInfo;
  final User? user;
  final void Function(int) onSelectedTab;
  final TabController tabController;

  const ReceiveDeliveryAuthorizationsPage({
    Key? key,
    required this.deliveries,
    required this.deliveryAuthorizations,
    required this.cabinetInfo,
    required this.listCabinetWithDeliveries,
    required this.bankTransferInfo,
    required this.user,
    required this.onSelectedTab,
    required this.tabController,
  }) : super(key: key);

  @override
  State<ReceiveDeliveryAuthorizationsPage> createState() => _ReceiveDeliveryAuthorizationsPageState();
}

class _ReceiveDeliveryAuthorizationsPageState extends BaseViewState<ReceiveDeliveryAuthorizationsPage, ReceiveDeliveryAuthorizationsPageViewModel> {
  @override
  ReceiveDeliveryAuthorizationsPageViewModel createViewModel() => locator<ReceiveDeliveryAuthorizationsPageViewModel>();

  @override
  void loadArguments() {
    viewModel.loadArguments(
      widget.deliveryAuthorizations,
      widget.cabinetInfo,
      widget.user,
      widget.bankTransferInfo,
      widget.listCabinetWithDeliveries,
    );
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  widget.deliveries.length.toString(),
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
                  viewModel.deliveryAuthorizations.length.toString(),
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
          child: viewModel.listCabinetWithDeliveries.isNotEmpty
              ? Column(children: [
                  Expanded(
                    child: CustomScrollView(slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          viewModel.deliveryAuthorizations.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(15.sp),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16.sp)), color: AppTheme.radiantGlow),
                                    child: Column(children: [
                                      SizedBox(height: 14.h),
                                      Row(children: [
                                        Container(
                                          width: 8.w,
                                          height: 46.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(16.sp), bottomRight: Radius.circular(16.sp)),
                                            color: AppTheme.gluttonyOrange,
                                          ),
                                        ),
                                        SizedBox(width: 14.h),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.cabinetInfo.name,
                                              style: AppTheme.black_16w600,
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              "• ${viewModel.deliveryAuthorizations.length} ${LocaleKeys.delivery_authorization_package.trans()}",
                                              style: AppTheme.hotOrange_14w400,
                                            ),
                                          ],
                                        ),
                                      ]),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(top: 13.h),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) => Obx(() => ReceiveDeliveryAuthorizationItem(
                                              deliveryAuthorization: viewModel.deliveryAuthorizations[index],
                                              onItemClick: () => viewModel.setSelectedDeliveryAuthorization(viewModel.deliveryAuthorizations[index]),
                                              selected: viewModel.selectedDeliveryAuthorization == viewModel.deliveryAuthorizations[index],
                                            )),
                                        itemCount: viewModel.deliveryAuthorizations.length,
                                      ),
                                    ]),
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
                            itemBuilder: (context, index) {
                              return widget.cabinetInfo.id != viewModel.listCabinetWithDeliveries[index].id
                                  ? AuthorizedPackagesFromAnotherCabinetsWidget(cabinetInfo: viewModel.listCabinetWithDeliveries[index])
                                  : Container();
                            },
                          ),
                          SizedBox(height: 10.h),
                        ]),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Visibility(
                      visible: viewModel.deliveryAuthorizations.isNotEmpty,
                      child: Container(
                        height: 50.h,
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        child: SizedBox.expand(
                          child: TapDebouncer(
                            onTap: () async => viewModel.receiveDeliveryAuthorization(),
                            builder: (context, onTap) => ElevatedButton(
                              onPressed: onTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.orange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                              ),
                              child: Center(child: Text(LocaleKeys.delivery_authorization_receive.trans(), style: AppTheme.white_16w600)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
              : Padding(padding: EdgeInsets.only(top: 67.h), child: EmptyReceiveDeliveryAuthorizationWidget(cabinetName: viewModel.cabinetInfo.name)),
        ),
      ],
    );
  }
}
