import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReceiveAuthorizationPackageItemFromAnotherCabinet extends StatelessWidget {
  const ReceiveAuthorizationPackageItemFromAnotherCabinet({
    Key? key,
    required this.deliveryAuthorization,
  }) : super(key: key);

  final DeliveryAuthorization deliveryAuthorization;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 22.w, right: 15.w, bottom: 13.h),
      padding: EdgeInsets.only(left: 22.w, right: 15.w, top: 13.h, bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppTheme.white,
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 5.w),
                      child: _getDeliveryIcon(deliveryAuthorization.delivery!.type),
                    ),
                    Text(
                      "ID ${FormatHelper.formatId(deliveryAuthorization.delivery?.id)}",
                      style: AppTheme.black_16bold,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              FormatHelper.formatCreatedDate(deliveryAuthorization.delivery?.updatedAt),
              style: AppTheme.grey_14w400,
              textAlign: TextAlign.end,
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Assets.icons.icDeliveryInfoPocket.image(width: 16.w, height: 16.h, color: AppTheme.leadOreGrey),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          "${LocaleKeys.delivery_pocket.trans()}: ",
                          style: AppTheme.grey_14w400,
                        ),
                        Text(
                          deliveryAuthorization.delivery?.extra?.pocketExtra?.localId.toString() ?? "",
                          style: AppTheme.blackDark_14w400,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 27.w,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Assets.icons.icDeliveryInfoMoney.image(width: 16.w, height: 16.h, color: AppTheme.leadOreGrey),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          "${LocaleKeys.delivery_rental_fee.trans()}: ",
                          style: AppTheme.grey_14w400,
                        ),
                        Text(
                          FormatHelper.formatCurrencyV2(
                            FormatHelper.roundSantaXu(deliveryAuthorization.delivery?.estimatedReceivingPrice ?? 0),
                          ),
                          style: AppTheme.blackDark_14w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.icons.icDeliveryInfoSenderPackage.image(
                  width: 16.w,
                  height: 16.h,
                  color: AppTheme.grey,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "${LocaleKeys.delivery_sender.trans()}: ",
                      style: AppTheme.grey_14w400,
                      children: [
                        TextSpan(
                          text: deliveryAuthorization.delivery?.sender?.displayPhoneNumberAndName ?? " ",
                          style: AppTheme.blackDark_14w400,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (deliveryAuthorization.delivery?.charity != null)
              GestureDetector(
                onTap: () => locator<Alice>().showInspector(),
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Assets.icons.icCharityDelivery.image(
                        width: 16.w,
                        height: 16.h,
                        color: AppTheme.neutral,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "${LocaleKeys.delivery_charity_org.trans()}: ",
                            style: AppTheme.grey_14w400,
                            children: [
                              TextSpan(
                                text: deliveryAuthorization.delivery?.charity?.name ?? "",
                                style: AppTheme.blackDark_14w400,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (deliveryAuthorization.delivery?.charityCampaign != null)
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Assets.icons.icDetailCharityCampaign.image(
                      width: 16.w,
                      height: 16.h,
                      color: AppTheme.neutral,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "${LocaleKeys.delivery_charity_campaign.trans()}: ",
                          style: AppTheme.grey_14w400,
                          children: [
                            TextSpan(
                              text: deliveryAuthorization.delivery?.charityCampaign?.name ?? "",
                              style: AppTheme.blackDark_14w400,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.icons.icAuthorizedPerson.image(
                  width: 16.w,
                  height: 16.h,
                  color: AppTheme.grey,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "${LocaleKeys.delivery_authorization_delivery_owner.trans()}: ",
                      style: AppTheme.grey_14w400,
                      children: [
                        TextSpan(
                          text: deliveryAuthorization.delivery?.receiver?.displayPhoneNumberAndName ?? "",
                          style: AppTheme.blackDark_14w400,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (deliveryAuthorization.delivery?.note != null && deliveryAuthorization.delivery?.note?.trim() != "")
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: [
                    Assets.icons.icDeliveryInfoNote.image(width: 16.w, height: 16.h, color: AppTheme.leadOreGrey),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      "${LocaleKeys.delivery_note.trans()}: ",
                      style: AppTheme.grey_14w400,
                    ),
                    Expanded(
                      child: Text(
                        deliveryAuthorization.delivery?.note ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.blackDark_14,
                      ),
                    ),
                    if ((deliveryAuthorization.delivery?.note ?? "").length > 28)
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 0,
                              child: SizedBox(
                                width: 319.w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20.h,
                                    horizontal: 20.w,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LocaleKeys.delivery_note.trans(),
                                            style: AppTheme.orange_14,
                                          ),
                                          InkWell(
                                            onTap: () => Get.back(),
                                            child: Icon(
                                              Icons.close,
                                              size: 16.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      const Divider(
                                        height: 1,
                                        color: AppTheme.grey,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                                        child: Text(
                                          deliveryAuthorization.delivery?.note ?? "",
                                          style: AppTheme.grey_14w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.delivery_see_more.trans(),
                          style: AppTheme.orange_14,
                        ),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getDeliveryIcon(DeliveryType type) {
    switch (type) {
      case DeliveryType.surprise:
        return Assets.icons.icSurpriseDeliveryGray.image();
      case DeliveryType.charity:
        return Assets.icons.icCharityDeliveryReceiveGray.image();
      case DeliveryType.unknown:
      case DeliveryType.mDefault:
      case DeliveryType.selfRentPocket:
      default:
        return Assets.icons.icDeliveryReceiveGray.image();
    }
  }
}
