import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/widgets/delivery_status_view.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/widgets/authorized_person_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityDeliveryDetailPage extends StatelessWidget {
  final int deliveryId;
  final DeliveryDetailPageViewModel viewModel;

  const CharityDeliveryDetailPage({Key? key, required this.deliveryId, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${LocaleKeys.charity_delivery_id.trans()} ${FormatHelper.formatId(viewModel.deliveryId)}",
          style: AppTheme.black_16w600,
        ),
        backgroundColor: AppTheme.danger2,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppTheme.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.onRefresh(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [AppTheme.carnationBloom.withOpacity(0.3), AppTheme.white],
              stops: const [
                0.01,
                0.6,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 16.h, bottom: 30.h),
                    child: Column(
                      children: [
                        Obx(
                          () => viewModel.checkHadAuthorize()
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: AuthorizedPersonWidget(
                                    textAuthorizedPerson: viewModel.authorizedPerson!,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        Obx(
                          () => viewModel.checkCanCancelAuthorize() && viewModel.isReceiver
                              ? TextButton(
                                  onPressed: () => viewModel.onCancelAuthorizedClicked(),
                                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 20.h),
                                    padding: EdgeInsets.symmetric(vertical: 6.h),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.white, boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.black.withOpacity(0.3),
                                        offset: const Offset(0, 0),
                                        spreadRadius: 0.3,
                                        blurRadius: 0.3,
                                      ),
                                    ]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Assets.icons.icDetailTrashBin.image(),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          LocaleKeys.charity_cancel_authorization.trans(),
                                          style: AppTheme.red_14w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        Obx(() => _estimatedFee()),
                        Obx(() => _delivery()),
                        Obx(() {
                          final unwrapDelivery = viewModel.delivery;
                          return unwrapDelivery != null ? _cabinetInfo(unwrapDelivery.packageCategory) : const SizedBox();
                        }),
                        Obx(() => _feeDelivery()),
                        Obx(() => _statusDelivery()),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: viewModel.isShowReopenButton(),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.h),
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.5.h)),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            side: BorderSide(color: viewModel.isDeliveryReOpenable ? AppTheme.yellow1 : AppTheme.creamOrange),
                          ),
                        ),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: viewModel.isDeliveryReOpenable ? viewModel.showReopenPocketDialog : null,
                      child: Text(
                        LocaleKeys.charity_open_pocket.trans(),
                        style: viewModel.isDeliveryReOpenable ? AppTheme.yellow1_14w600 : AppTheme.creamOrange_14w600,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () {
                  final user = viewModel.currentUser;
                  return user != null && (!viewModel.deliveryCanceled && !viewModel.deliveryReceived)
                      ? viewModel.isReceiver
                          ? Visibility(
                              visible: viewModel.delivery?.status == DeliveryStatus.sent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.h),
                                child: Row(children: [
                                  Expanded(
                                    child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 14.5.h),
                                        backgroundColor: AppTheme.cyan,
                                        disabledBackgroundColor: AppTheme.cyan.withOpacity(0.4),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                                      ),
                                      onPressed: viewModel.checkHadAuthorize() ? null : viewModel.showAuthorizeDialog,
                                      child: Text(
                                        LocaleKeys.charity_authorize.trans(),
                                        style: viewModel.checkHadAuthorize()
                                            ? AppTheme.blackDark_16w600.copyWith(color: AppTheme.blackDark.withOpacity(0.4))
                                            : AppTheme.blackDark_16w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 14.5.h),
                                        backgroundColor: AppTheme.orange,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                                      ),
                                      onPressed: () {
                                        viewModel.receiveDelivery();
                                      },
                                      child: Text(LocaleKeys.charity_receive.trans(), style: AppTheme.blackDark_16w600),
                                    ),
                                  ),
                                ]),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(color: viewModel.countDown > 0 ? AppTheme.red : Colors.transparent),
                                color: viewModel.countDown > 0 ? AppTheme.white : AppTheme.greyText,
                              ),
                              width: double.infinity,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14.5.h),
                                  elevation: 0,
                                ),
                                onPressed: viewModel.countDown > 0 ? viewModel.onCancelDeliveryClicked : null,
                                child: Text(
                                  "${viewModel.countDown > 0 ? LocaleKeys.charity_cancel.trans() : LocaleKeys.charity_canceling_was_expired.trans()} (${viewModel.countDownString()})",
                                  style: viewModel.countDown > 0 ? AppTheme.red_14w600 : AppTheme.greyIcon_14w600,
                                ),
                              ),
                            )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _estimatedFee() {
    return viewModel.isReceiver && viewModel.delivery?.status == DeliveryStatus.sent
        ? Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.icons.icRectangle.path),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              children: [
                Text(
                  LocaleKeys.charity_estimated_fee.trans(),
                  style: AppTheme.blackDark_16w700,
                ),
                const Spacer(),
                FittedBox(
                  child: Text(
                    FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.estimatedReceivingPrice ?? 0)),
                    style: AppTheme.blackDarkOp50Percent_14w400,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Container _delivery() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5.w),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 8.h, right: 15.w),
            child: Row(
              children: [
                Text(
                  LocaleKeys.charity_delivery.trans(),
                  style: AppTheme.blackDark_16w700,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => viewModel.navigateCabinetDetail(),
                  child: Text(
                    LocaleKeys.charity_view_detail.trans(),
                    style: AppTheme.yellow_14w400,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.h,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          SizedBox(
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.delivery?.cabinet?.name ?? "",
                  style: AppTheme.blackDark_14w700,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  viewModel.delivery?.cabinet?.location?.address ?? "",
                  style: AppTheme.blackDarkOp50Percent_14w400,
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "${LocaleKeys.charity_pocket.trans()} ${viewModel.delivery?.extra?.pocketExtra?.localId ?? ""}",
                  style: AppTheme.blackDark_14w700,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "${LocaleKeys.charity_size.trans()}: ${viewModel.delivery?.pocket?.size?.name ?? ""}",
                  style: AppTheme.blackDarkOp50Percent_14w400,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }

  Container _cabinetInfo(PackageCategory? categoryType) {
    Widget getIcon() {
      switch (categoryType) {
        case PackageCategory.food:
          return Assets.icons.icCategoryFood.image(width: 24.w, height: 24.h);
        case PackageCategory.others:
          return Assets.icons.icCatagoryOther.image(width: 24.w, height: 24.h);
        default:
          return Assets.icons.icCatagoryOther.image(width: 24.w, height: 24.h);
      }
    }

    Widget getIconText() {
      switch (categoryType) {
        case PackageCategory.food:
          return Text(
            LocaleKeys.charity_food.trans(),
            style: AppTheme.blackDark_14w600,
          );
        case PackageCategory.others:
          return Text(
            LocaleKeys.charity_others.trans(),
            style: AppTheme.blackDark_14w600,
          );
        default:
          return Text(
            LocaleKeys.charity_others.trans(),
            style: AppTheme.blackDark_14w600,
          );
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5.w),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: Row(
              children: [
                Text(
                  LocaleKeys.charity_info.trans(),
                  style: AppTheme.blackDark_16w700,
                ),
                const Spacer(),
                getIcon(),
                SizedBox(
                  width: 15.w,
                ),
                getIconText(),
              ],
            ),
          ),
          Divider(
            height: 1.h,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          Visibility(
            visible: viewModel.isShowCharityInfo,
            child: Container(
              margin: EdgeInsets.all(14.sp),
              padding: EdgeInsets.all(10.sp),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lomonadePink,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.r),
                ),
                border: Border.all(color: AppTheme.pearchBurst),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: viewModel.delivery?.charity != null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.charity_charity_org.trans(),
                          style: AppTheme.blackDark_14w700,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          viewModel.delivery?.charity?.name ?? "",
                          style: AppTheme.blackDark_14w400,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: viewModel.delivery?.charityCampaign != null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.charity_charity_campaign.trans(),
                          style: AppTheme.blackDark_14w700,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          viewModel.delivery?.charityCampaign?.name ?? "",
                          style: AppTheme.blackDark_14w400,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 38.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Assets.icons.icDetailSenderRounded.image(
                          height: 34.h,
                          width: 34.w,
                        ),
                        DottedLine(
                          direction: Axis.vertical,
                          lineLength: 40.h,
                          dashColor: AppTheme.grey,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.charity_sender.trans(),
                            style: AppTheme.blackDark_14w700,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${viewModel.delivery?.sender?.phoneNumber ?? " "} ${viewModel.senderName}",
                            style: AppTheme.blackDark_14w400,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        viewModel.isReceivedByReceiver()
                            ? Assets.icons.icDetailReceiverRoundedAuth.image(
                                height: 34.h,
                                width: 34.w,
                              )
                            : Assets.icons.icDetailReceiverRounded.image(
                                height: 34.h,
                                width: 34.w,
                              ),
                        Visibility(
                          visible: viewModel.checkHadAuthorize(),
                          child: DottedLine(
                            direction: Axis.vertical,
                            lineLength: 40.h,
                            dashColor: AppTheme.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.charity_receiver.trans(),
                            style: AppTheme.blackDark_14w700,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${viewModel.delivery?.receiver?.phoneNumber ?? " "} ${viewModel.receiverName}",
                            style: AppTheme.blackDark_14w400,
                            softWrap: true,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: viewModel.checkHadAuthorize(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      viewModel.isReceivedByAuthorization
                          ? Assets.icons.icDetailAuthorizationDelivery.image(
                              height: 34.h,
                              width: 34.w,
                            )
                          : Assets.icons.icDetailAuthorizationDeliveryUnauth.image(
                              height: 34.h,
                              width: 34.w,
                            ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.charity_proxy.trans(),
                              style: AppTheme.blackDark_14w700,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "${viewModel.delivery?.authorization?.user?.phoneNumber ?? " "} ${viewModel.authorizationName}",
                              style: AppTheme.blackDark_14w400,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if ((viewModel.delivery?.note?.trim() != ""))
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 17.w, right: 17.w, top: 16.h),
              padding: EdgeInsets.only(left: 21.w, top: 11.h, right: 12.w, bottom: 18.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: const Color(0xFFF9F7F4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.charity_note.trans(),
                    style: AppTheme.blackDark_14w700,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    viewModel.delivery?.note ?? " ",
                    style: AppTheme.blackDark_14w400,
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 12.h,
          ),
        ],
      ),
    );
  }

  Container _feeDelivery() {
    return viewModel.deliveryReceived
        ? Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5.w),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys.charity_service_fee.trans(),
                        style: AppTheme.blackDark_16w700,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1.h,
                  color: AppTheme.grey.withOpacity(0.5),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            LocaleKeys.charity_receiving_fee.trans(),
                            style: AppTheme.neutral_14w400,
                          ),
                          const Spacer(),
                          Text(
                            FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.receivingPrice ?? 0)),
                            style: AppTheme.neutral_14w400,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      if ((viewModel.delivery?.chargedAmount ?? 0) > 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.charity_charging_fee.trans(),
                                style: AppTheme.blackDarkOp50Percent_14w400,
                              ),
                              const Spacer(),
                              Text(
                                FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.chargedAmount ?? 0)),
                                style: AppTheme.blackDarkOp50Percent_14w400,
                              ),
                            ],
                          ),
                        ),
                      if ((viewModel.delivery?.refundedAmount ?? 0) > 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.charity_refunded_amount.trans(),
                                style: AppTheme.blackDarkOp50Percent_14w400,
                              ),
                              const Spacer(),
                              Text(
                                "-${FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.refundedAmount ?? 0))}",
                                style: AppTheme.blackDarkOp50Percent_14w400,
                              ),
                            ],
                          ),
                        ),
                      DottedLine(
                        dashColor: AppTheme.grey.withOpacity(0.5),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          Text(
                            LocaleKeys.charity_total.trans(),
                            style: AppTheme.red1_14w400,
                          ),
                          const Spacer(),
                          Text(
                            FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.totalFee ?? 0)),
                            style: AppTheme.red_14w700,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      if ((viewModel.delivery?.coinAmount ?? 0) > 0)
                        Row(
                          children: [
                            Text(
                              LocaleKeys.charity_santa_coins.trans(),
                              style: AppTheme.blackDarkOp50Percent_14w400,
                            ),
                            const Spacer(),
                            Text(
                              FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.coinAmount ?? 0), unit: ""),
                              style: AppTheme.orangeDark2_14,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Container _statusDelivery() {
    return viewModel.statusLogs.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5.w)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                child: Text(LocaleKeys.charity_status.trans(), style: AppTheme.blackDark_16w700),
              ),
              Divider(height: 1.h, color: AppTheme.grey.withOpacity(0.5)),
              SizedBox(height: 12.h),
              ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (index == viewModel.statusLogs.length - 1)
                      DeliveryStatusView(statusLog: viewModel.statusLogs[index], isLastStatus: true)
                    else
                      DeliveryStatusView(statusLog: viewModel.statusLogs[index], isLastStatus: false),
                    if (index != 0) Container(margin: EdgeInsets.only(left: 24.w), color: AppTheme.grey.withOpacity(0.5), height: 35.h, width: 1.w),
                  ]);
                },
                itemCount: viewModel.statusLogs.length,
              ),
              SizedBox(height: 12.h),
            ]),
          )
        : Container();
  }
}
