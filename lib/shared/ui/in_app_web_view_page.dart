import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:santapocket/shared/ui/in_app_web_view_page_view_model.dart';
import 'package:suga_core/suga_core.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;

  const InAppWebViewPage({required this.url, Key? key}) : super(key: key);

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends BaseViewState<InAppWebViewPage, InAppWebViewPageViewModel> {
  @override
  InAppWebViewPageViewModel createViewModel() => locator<InAppWebViewPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.goldishOrange,
        leading: GestureDetector(onTap: () => Get.back(), child: Assets.icons.icLogoWebview.image()),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              onTap: () => viewModel.reloadWebView(),
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            InAppWebView(
              key: viewModel.webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: viewModel.settings,
              onWebViewCreated: (controller) {
                viewModel.setWebViewController(controller);
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
              onProgressChanged: viewModel.onProgressChanged,
            ),
            Visibility(
              visible: viewModel.progress < 1.0,
              child: Center(
                child: SizedBox(
                  width: 35.w,
                  height: 35.w,
                  child: const FittedBox(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.orange),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
