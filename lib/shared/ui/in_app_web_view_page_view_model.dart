import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/permission_helper.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class InAppWebViewPageViewModel extends AppViewModel {
  InAppWebViewPageViewModel();

  final _progress = Rx<double>(0.0);

  final javascriptHandlerOpenUrlChannel = "sm/open_url";
  final javascriptHandlerGetUserLocationChannel = "sm/get_user_location";
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  final InAppWebViewSettings _settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    clearCache: true,
  );

  GlobalKey get webViewKey => _webViewKey;

  InAppWebViewController? get webViewController => _webViewController;

  InAppWebViewSettings get settings => _settings;

  double get progress => _progress.value;

  @override
  void disposeState() {
    _webViewController?.dispose();
    super.disposeState();
  }

  void setWebViewController(InAppWebViewController controller) {
    controller.addJavaScriptHandler(handlerName: javascriptHandlerGetUserLocationChannel, callback: _handleJavascriptGetUserLocation);
    controller.addJavaScriptHandler(handlerName: javascriptHandlerOpenUrlChannel, callback: _handleJavascriptOpenUrl);
    _webViewController = controller;
  }

  Future<Map<String, dynamic>> _handleJavascriptOpenUrl(List<dynamic> arg) async {
    final result = <String, dynamic>{};
    if (arg.isNotEmpty && arg.first is Map<String, dynamic>) {
      final map = arg.first as Map<String, dynamic>;
      final url = map['url'] as String;
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await run(() => launchUrl(uri, mode: LaunchMode.externalApplication));
        result['error'] = 0;
        return result;
      }
    }
    result['error'] = 1;
    result['message'] = "Could not launch url";
    return result;
  }

  Future<Map<String, dynamic>> _handleJavascriptGetUserLocation(List<dynamic> arg) async {
    final result = <String, dynamic>{};
    final isLocationPermissionGranted = await PermissionHelper.instance.checkPermission(Permission.location, forceRequest: false);
    if (isLocationPermissionGranted) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Position? curPosition;
        await run(
          () async => curPosition = await Geolocator.getCurrentPosition(),
        );
        if (curPosition != null) {
          final resultData = <String, dynamic>{};
          resultData['lat'] = curPosition!.latitude;
          resultData['lng'] = curPosition!.longitude;
          resultData['timestamp'] = curPosition!.timestamp?.millisecondsSinceEpoch ?? 0;
          result['error'] = 0;
          result['data'] = resultData;
          return result;
        }
      }
    }
    result['error'] = 1;
    result['message'] = "Could not get your location, please enable location service and try again";
    return result;
  }

  void onProgressChanged(InAppWebViewController controller, int progress) => _progress.value = progress / 100;

  Future<Unit> reloadWebView() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _webViewController?.reload();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _webViewController?.loadUrl(
        urlRequest: URLRequest(url: await _webViewController?.getUrl()),
      );
    }

    return unit;
  }
}
