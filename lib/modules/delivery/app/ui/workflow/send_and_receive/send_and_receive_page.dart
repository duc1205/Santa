import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send_and_receive/send_and_receive_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class SendAndReceivePage extends StatefulWidget {
  final CabinetInfo cabinetInfo;

  const SendAndReceivePage({
    Key? key,
    required this.cabinetInfo,
  }) : super(key: key);

  @override
  State<SendAndReceivePage> createState() => _SendAndReceivePageState();
}

class _SendAndReceivePageState extends BaseViewState<SendAndReceivePage, SendAndReceivePageViewModel> {
  @override
  SendAndReceivePageViewModel createViewModel() => locator<SendAndReceivePageViewModel>();

  @override
  void loadArguments() {
    viewModel.cabinetInfo = widget.cabinetInfo;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.imgBackground.path),
              fit: BoxFit.fill,
            ),
            color: AppTheme.radiantGlow,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Assets.icons.icClose.image(
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 72.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.imgAppWithoutSlogan.image(
                      height: 66.h,
                      width: 117.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 80.h,
                ),
                Assets.icons.icSendAndReceiveActivity.image(
                  height: 124.h,
                  width: 280.w,
                ),
                SizedBox(
                  height: 22.h,
                ),
                Text(
                  LocaleKeys.delivery_app_intro.trans(),
                  style: AppTheme.black_18w600,
                ),
                Text(
                  LocaleKeys.delivery_app_slogan.trans(),
                  style: AppTheme.grey_17w400SSP,
                ),
                SizedBox(
                  height: 48.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: viewModel.onClickButtonSend,
                        child: Container(
                          padding: EdgeInsets.only(top: 16.h),
                          height: 120.h,
                          width: 175.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.icons.icSendAndReceiveBlackBox.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Assets.icons.icSendAndReceiveSender.image(
                                width: 68.w,
                                height: 53.h,
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                LocaleKeys.delivery_send.trans().toUpperCase(),
                                style: AppTheme.orange_22w700SSP,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: viewModel.onClickButtonReceive,
                          child: Container(
                            padding: EdgeInsets.only(top: 16.h),
                            height: 120.h,
                            width: 175.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(Assets.icons.icSendAndReceiveYellowBox.path), fit: BoxFit.cover),
                            ),
                            child: Column(
                              children: [
                                Assets.icons.icSendAndReceiveReceive.image(
                                  width: 53.w,
                                  height: 53.h,
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Text(
                                  LocaleKeys.delivery_receive.trans().toUpperCase(),
                                  style: AppTheme.blackDark_22w700SSP,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
