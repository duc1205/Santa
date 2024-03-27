import 'package:santapocket/config/config.dart';

class RemoteImageResizeHelper {
  RemoteImageResizeHelper._();

  static String getImageResize(String url, double w, double h) {
    String method = "display";
    String operation = "resize";
    return "${Config.remoteImageResizeBaseUrl}/$method?url=$url&w=${w.toInt()}&h=${h.toInt()}&op=$operation&upscale=0";
  }
}
