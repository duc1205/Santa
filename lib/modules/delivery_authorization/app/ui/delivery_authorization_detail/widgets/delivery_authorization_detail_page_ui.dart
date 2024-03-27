import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/widgets/delivery_status_view.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery_status_log.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page_viewmodel.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/widgets/authorized_person_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class DeliveryAuthorizationDetailPageUI extends StatelessWidget {
  final DeliveryAuthorizationDetailPageViewModel viewModel;

  const DeliveryAuthorizationDetailPageUI({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${LocaleKeys.delivery_authorization_delivery_id.trans()} ${FormatHelper.formatId(viewModel.delivery?.id)}",
          style: AppTheme.black_16w600,
        ),
        backgroundColor: AppTheme.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppTheme.black),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: RefreshIndicator(
                  onRefresh: viewModel.onRefresh,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 16.h, bottom: 30.h),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: Obx(
                            () => AuthorizedPersonWidget(
                              textAuthorizedPerson: viewModel.authorizedPerson,
                            ),
                          ),
                        ),
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
            ),
            Visibility(
              visible: !viewModel.checkIsDeliveryAuthorizationCompleted(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.h),
                child: Row(
                  children: [
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
                        child: Text(LocaleKeys.delivery_authorization_receive.trans(), style: AppTheme.blackDark_16w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _delivery() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 8.h, right: 15.w),
            child: Row(
              children: [
                Text(
                  LocaleKeys.delivery_authorization_delivery.trans(),
                  style: AppTheme.blackDark_16w700,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => viewModel.navigateCabinetDetail(),
                  child: Text(
                    LocaleKeys.delivery_authorization_view_detail.trans(),
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
                  "${LocaleKeys.delivery_authorization_pocket.trans()} ${viewModel.delivery?.extra?.pocketExtra?.localId ?? ""}",
                  style: AppTheme.blackDark_14w700,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "${LocaleKeys.delivery_authorization_size.trans()}: ${viewModel.delivery?.pocket?.size?.name ?? ""}",
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
            LocaleKeys.delivery_authorization_food.trans(),
            style: AppTheme.blackDark_14w600,
          );
        case PackageCategory.others:
          return Text(
            LocaleKeys.delivery_authorization_others.trans(),
            style: AppTheme.blackDark_14w600,
          );
        default:
          return Text(
            LocaleKeys.delivery_authorization_others.trans(),
            style: AppTheme.blackDark_14w600,
          );
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: Row(
              children: [
                Text(
                  LocaleKeys.delivery_authorization_info.trans(),
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
          SizedBox(
            height: 12.h,
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
                          lineLength: 50.h,
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
                            LocaleKeys.delivery_authorization_sender.trans(),
                            style: AppTheme.blackDark_14w700,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${viewModel.delivery?.sender?.phoneNumber ?? " "} ${viewModel.senderName}",
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Assets.icons.icDetailReceiverRounded.image(
                          height: 34.h,
                          width: 34.w,
                        ),
                        DottedLine(
                          direction: Axis.vertical,
                          lineLength: 50.h,
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
                            LocaleKeys.delivery_authorization_receiver.trans(),
                            style: AppTheme.blackDark_14w700,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${viewModel.delivery?.receiver?.phoneNumber ?? " "} ${viewModel.receiverName}",
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    viewModel.delivery?.authorization?.isReceived == true
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
                            LocaleKeys.delivery_authorization_proxy.trans(),
                            style: AppTheme.blackDark_14w700,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            viewModel.proxyPerson,
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
              ],
            ),
          ),
          if (viewModel.delivery?.note?.trim() != "")
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
                    LocaleKeys.delivery_authorization_note.trans(),
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: Text(
                    LocaleKeys.delivery_authorization_service_fee.trans(),
                    style: AppTheme.blackDark_16w700,
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
                            LocaleKeys.delivery_authorization_receiving_fee.trans(),
                            style: AppTheme.blackDarkOp50Percent_14w400,
                          ),
                          const Spacer(),
                          Text(
                            FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.receivingPrice ?? 0)),
                            style: AppTheme.blackDarkOp50Percent_14w400,
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
                                LocaleKeys.delivery_authorization_charging_fee.trans(),
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
                                LocaleKeys.delivery_authorization_refunded_amount.trans(),
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
                            LocaleKeys.delivery_authorization_total.trans(),
                            style: AppTheme.blackDarkOp50Percent_14w700,
                          ),
                          const Spacer(),
                          Text(
                            FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(viewModel.delivery?.totalFee ?? 0)),
                            style: AppTheme.red_14w700,
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
    final List<DeliveryStatusLog> statusLogs = viewModel.statusLogs;
    return statusLogs.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                color: AppTheme.grey.withOpacity(0.5),
                width: 0.5.w,
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                child: Text(LocaleKeys.delivery_authorization_status.trans(), style: AppTheme.blackDark_16w700),
              ),
              Divider(height: 1.h, color: AppTheme.grey.withOpacity(0.5)),
              SizedBox(height: 12.h),
              ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (index == statusLogs.length - 1)
                      DeliveryStatusView(statusLog: statusLogs[index], isLastStatus: true)
                    else
                      DeliveryStatusView(statusLog: statusLogs[index], isLastStatus: false),
                    if (index != 0)
                      Container(
                        margin: EdgeInsets.only(left: 24.w),
                        color: AppTheme.grey.withOpacity(0.5),
                        height: 35.h,
                        width: 1.w,
                      ),
                  ]);
                },
                itemCount: statusLogs.length,
              ),
              SizedBox(height: 12.h),
            ]),
          )
        : Container();
  }
}
