import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/modules/charity/app/ui/workflow/result/fail/charity_delivery_failed_page_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CharityDeliveryFailedPage extends StatefulWidget {
  const CharityDeliveryFailedPage({Key? key, this.deliveryId, required this.cabinetInfo}) : super(key: key);

  final int? deliveryId;
  final CabinetInfo cabinetInfo;

  @override
  State<CharityDeliveryFailedPage> createState() => _CharityDeliveryFailedPageState();
}

class _CharityDeliveryFailedPageState extends BaseViewState<CharityDeliveryFailedPage, CharityDeliveryFailedPageViewModel> {
  @override
  CharityDeliveryFailedPageViewModel createViewModel() => locator<CharityDeliveryFailedPageViewModel>();

  @override
  void loadArguments() {
    viewModel.deliveryId = widget.deliveryId!;
    viewModel.cabinetInfo = widget.cabinetInfo;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "${LocaleKeys.delivery_delivery_id.trans().toUpperCase()} #${widget.deliveryId}",
              style: AppTheme.black_16w600,
            ),
          ),
          body: Column(
            children: [
              const DeliveryStepsWidget(
                step: 3,
                isReceiving: true,
                isLastStepFailed: true,
              ),
              SizedBox(
                height: 85.h,
              ),
              Assets.images.imgDeliveryFail.image(
                width: 294.w,
                height: 171.h,
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Ooops…",
                style: AppTheme.red_20w600,
              ),
              SizedBox(
                height: 9.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Text(
                  LocaleKeys.charity_delivery_wrong.trans(),
                  style: AppTheme.blackDark_16w400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => callHotLine(viewModel.bankTransferInfo["contacts"]["call"]["value"]),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Container(
                        width: 130.w,
                        padding: EdgeInsets.only(
                          top: 4.h,
                          bottom: 10.h,
                        ),
                        child: Column(
                          children: [
                            Assets.icons.icPhone.image(),
                            SizedBox(
                              height: 6.h,
                            ),
                            Text(
                              LocaleKeys.charity_call_hotline.trans(),
                              style: AppTheme.black_14w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUri("http://zalo.me/${viewModel.bankTransferInfo["contacts"]["zalo"]["value"]}");
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Container(
                        width: 130.w,
                        padding: EdgeInsets.only(
                          top: 4.h,
                          bottom: 10.h,
                        ),
                        child: Column(
                          children: [
                            Assets.icons.icHomeZalo.image(),
                            SizedBox(
                              height: 6.h,
                            ),
                            Text(
                              LocaleKeys.charity_chat_zalo.trans(),
                              style: AppTheme.black_14w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Obx(
                () => Visibility(
                  visible: viewModel.isDeliveryReopenable,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SizedBox(
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.deliveryId != null) {
                            viewModel.reopenPocket();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            side: BorderSide(color: AppTheme.orange, width: 1.w),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.charity_reopen_pocket.trans(),
                            style: AppTheme.orange_16w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => backPageOrHome(pageName: CharityPage.routeName),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppTheme.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        LocaleKeys.charity_back_home.trans(),
                        style: AppTheme.white_16w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
