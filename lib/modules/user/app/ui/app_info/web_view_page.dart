import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({required this.url, Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;
  bool isError = false;
  WebViewController? _webViewController;

  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  void initState() {
    _configWebController();
    super.initState();
  }

  Future<void> _configWebController() async {
    final PlatformWebViewControllerCreationParams params = WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : const PlatformWebViewControllerCreationParams();
    _webViewController = WebViewController.fromPlatformCreationParams(params);
    await _webViewController?.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _webViewController?.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        },
        onWebResourceError: (WebResourceError error) {
          setState(() {
            isLoading = false;
            isError = true;
          });
        },
      ),
    );

    if (_webViewController?.platform is AndroidWebViewController) {
      await AndroidWebViewController.enableDebugging(true);
      await (_webViewController?.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    await _webViewController?.clearCache();
    await _webViewController?.clearLocalStorage();
    await cookieManager.clearCookies();
    try {
      final uri = Uri.parse(widget.url);
      if (uri.hasScheme) {
        await _webViewController?.loadRequest(uri);
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
        showToast("Not support for this scheme");
      }
    } on FormatException catch (_) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      showToast("Invalid URL");
    }
  }

  Future<Unit> reloadWebView() async {
    if (isError) {
      await _webViewController?.loadRequest(Uri.parse(widget.url));
      setState(() {
        isLoading = true;
        isError = false;
      });
    } else {
      await _webViewController?.reload();
      setState(() {
        isLoading = true;
      });
    }
    return unit;
  }

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
              onTap: () => reloadWebView(),
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              WebViewWidget(
                controller: _webViewController!,
              ),
              Visibility(
                visible: isLoading,
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
          );
        },
      ),
    );
  }
}
