import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CharityWebViewWithSize extends StatefulWidget {
  final double height;
  final double width;
  final String url;

  const CharityWebViewWithSize({required this.height, required this.width, required this.url, Key? key}) : super(key: key);

  @override
  State<CharityWebViewWithSize> createState() => _CharityWebViewWithSizeState();
}

class _CharityWebViewWithSizeState extends State<CharityWebViewWithSize> {
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
    _webViewController = WebViewController();
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
    await cookieManager.clearCookies();
    await _webViewController?.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return SizedBox(
          height: widget.height,
          width: widget.width,
          child: WebViewWidget(
            controller: _webViewController!,
          ),
        );
      },
    );
  }
}
