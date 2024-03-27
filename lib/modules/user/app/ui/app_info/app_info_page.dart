import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/app/ui/app_info/app_info_viewmodel.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:suga_core/suga_core.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends BaseViewState<AppInfoPage, AppInfoViewModel> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  AppInfoViewModel createViewModel() => locator<AppInfoViewModel>();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppTheme.orange,
        elevation: 1,
        centerTitle: true,
        title: Text(
          LocaleKeys.user_app_info.trans().toUpperCase(),
          style: AppTheme.white_16,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Title(
              version: _packageInfo.version,
            ),
            Body(
              viewModel: viewModel,
            ),
            SizedBox(
              height: 14.h,
            ),
            Bottom(
              viewModel: viewModel,
            ),
          ],
        ),
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  final AppInfoViewModel viewModel;

  const Bottom({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.user_customer_service.trans(),
          style: AppTheme.grey_14w600,
        ),
        SizedBox(
          height: 5.h,
        ),
        Wrap(
          children: [
            Text(
              "${LocaleKeys.user_call.trans()}: ",
              style: AppTheme.grey_14w600,
            ),
            InkWell(
              onTap: () async {
                final bool loading = await viewModel.makePhoneCall("0974 549 066");
                if (!loading) showToast(viewModel.getErrorMessage());
              },
              child: Text(
                "0974 549 066",
                style: TextStyle(
                  color: const Color(0xff6e91f4),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Wrap(
          children: [
            Text(
              "${LocaleKeys.user_chat.trans()}: ",
              style: AppTheme.grey_14w600,
            ),
            InkWell(
              onTap: () => launchUri("https://zalo.me/4441165801187962165"),
              child: Text(
                "https://zalo.me/4441165801187962165",
                style: TextStyle(
                  color: const Color(0xff6e91f4),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Wrap(
          children: [
            Text(
              'Email: ',
              style: AppTheme.grey_14w600,
            ),
            InkWell(
              onTap: () async {
                final bool loading = await viewModel.sendEmail('info.santapocket@suga.vn');
                if (!loading) showToast(viewModel.getErrorMessage());
              },
              child: Text(
                "info.santapocket@suga.vn",
                style: TextStyle(
                  color: const Color(0xff6e91f4),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          LocaleKeys.user_develop_by.trans(),
          style: AppTheme.grey_14w600,
        ),
        SizedBox(
          height: 7.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            LocaleKeys.user_address_company.trans(),
            style: AppTheme.grey_14w600,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${LocaleKeys.user_phone_number.trans()}: ",
              style: AppTheme.grey_14w600,
            ),
            InkWell(
              onTap: () async {
                final bool loading = await viewModel.makePhoneCall("028 6251 5775");
                if (!loading) showToast(viewModel.getErrorMessage());
              },
              child: Text(
                '(+84) 28 6251 5775',
                style: TextStyle(
                  color: const Color(0xff6e91f4),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email: ',
              style: AppTheme.grey_14w600,
            ),
            InkWell(
              onTap: () async {
                final bool loading = await viewModel.sendEmail('info.santapocket@santapocket.com');
                if (!loading) showToast(viewModel.getErrorMessage());
              },
              child: Text(
                'info.santapocket@santapocket.com',
                style: TextStyle(
                  color: const Color(0xff6e91f4),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 11.h,
        ),
        InkWell(
          onTap: () async {
            final bool loading = await viewModel.openLinkGov();
            if (!loading) {
              showToast(viewModel.getErrorMessage());
            }
          },
          child: Assets.images.imgAppInfoGov.image(
            height: 43.h,
            width: 115.w,
          ),
        ),
        SizedBox(
          height: 21.h,
        ),
      ],
    );
  }
}

class Body extends StatelessWidget {
  final AppInfoViewModel viewModel;

  const Body({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                BuildRow(
                  label: LocaleKeys.user_rate_app.trans(),
                  action: () {
                    StoreRedirect.redirect(
                      androidAppId: 'com.sugamobile.santapocket',
                      iOSAppId: '1507758260',
                    );
                  },
                ),
                Divider(
                  color: Colors.grey,
                  height: 1.h,
                ),
                BuildRow(
                  label: LocaleKeys.user_fanpage_app.trans(),
                  action: () => viewModel.openFanPage(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
            width: double.infinity,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Color(0xffeeeeee)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                BuildRow(
                  label: LocaleKeys.user_terms_and_conditions.trans(),
                  action: () {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          url: viewModel.urlTerms,
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  color: Colors.grey,
                  height: 1.h,
                ),
                BuildRow(
                  label: LocaleKeys.user_privacy_policy.trans(),
                  action: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                        url: viewModel.urlPrivacy,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 1.h,
                ),
                BuildRow(
                  label: LocaleKeys.user_locker_rental_fee.trans(),
                  action: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                        url: viewModel.urlLockerRentalFee,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildRow extends StatelessWidget {
  final String label;
  final Function() action;

  const BuildRow({
    required this.label,
    required this.action,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => action(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.black_14,
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String version;

  const Title({
    required this.version,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int countToEnableDeveloperMode = 5;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.orange,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Assets.images.imgAppLogoWhite.image(
            height: 66.h,
            width: 153.w,
          ),
          SizedBox(
            height: 15.h,
          ),
          GestureDetector(
            onTap: () async {
              if (countToEnableDeveloperMode == 0) {
                final developerModeEnable = await SPref.instance.getDeveloperModeEnable();
                if (developerModeEnable) {
                  showToast("Disable Developer Mode. Please restart app!");
                } else {
                  showToast("Enable Developer Mode. Please restart app!");
                }
                await SPref.instance.setDeveloperModeEnable(!developerModeEnable);
                countToEnableDeveloperMode = 5;
              }
              countToEnableDeveloperMode--;
            },
            child: Text(
              'Version  $version',
              style: AppTheme.white_14,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
