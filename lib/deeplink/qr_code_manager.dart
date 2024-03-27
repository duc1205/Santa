import 'dart:convert';

import 'package:santapocket/modules/cabinet/domain/models/qr_data.dart';
import 'package:santapocket/storage/spref.dart';

class QrCodeManager {
  static final QrCodeManager instance = QrCodeManager._internal();

  QrCodeManager._internal();

  static const _santaDeepLink = "https://deeplink.santapocket.com";
  static const _conciseSantaDeepLink = "https://c.santapocket.com";
  static const _surpriseDeepLink = "https://surprise.santapocket.com";

  Future<ParseQrStatus> parseQrData(String qrData) async {
    if (qrData.isEmpty) {
      return ParseQrStatus.error('Invalid QR');
    } else if (qrData.startsWith(_santaDeepLink)) {
      return analyzeDeepLink(qrData);
    } else if (qrData.startsWith(_conciseSantaDeepLink)) {
      return analyzeConciseDeepLink(qrData);
    } else if (qrData.startsWith(_surpriseDeepLink)) {
      return analyzeSurpriseDeepLink(qrData);
    } else {
      try {
        return _analyzeJsonQr(qrData);
      } on FormatException catch (e) {
        return ParseQrStatus.error(e.toString());
      }
    }
  }

  ParseQrStatus _analyzeJsonQr(String qrData) {
    final Map<String, dynamic> jsonData = json.decode(qrData) as Map<String, dynamic>;
    final product = jsonData["product"] ?? "";
    if (product == "santapocket") {
      final cabinetScanData = QrData.fromJson(jsonData);
      if (cabinetScanData.type == "cabinet_info") {
        return ParseQrStatus.success(cabinetScanData.data?['cabinet_uuid'].toString(), cabinetScanData.otp);
      }
    }
    return ParseQrStatus.error('Invalid QR');
  }

  ParseQrStatus analyzeDeepLink(String link) {
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;
    if (queryParams.containsKey("type") && queryParams["type"] == "cabinet_info" && queryParams.containsKey("cabinet_uuid")) {
      // return cabinet_list Uuid
      return ParseQrStatus.success(queryParams["cabinet_uuid"], queryParams["otp"]);
    } else {}
    return ParseQrStatus.error('Invalid QR');
  }

  ParseQrStatus analyzeConciseDeepLink(String link) {
    final uri = Uri.parse(link);
    if (uri.path.isNotEmpty) {
      String path = uri.path;
      if ('/'.allMatches(path).length == 2) {
        final splitted = path.split('/');
        String uuid = splitted[1];
        String otp = splitted[2];
        return ParseQrStatus.success(uuid, otp);
      } else {
        String uuid = path.replaceAll('/', '');
        return ParseQrStatus.success(uuid, "");
      }
    }
    return ParseQrStatus.error('Invalid QR');
  }

  Future<ParseQrStatus> analyzeSurpriseDeepLink(String link) async {
    final accessToken = await SPref.instance.getAccessToken();
    link += "?src=app&access_token=$accessToken";
    return ParseQrStatus.surprise(link);
  }
}

class ParseQrStatus {
  ParseQrStatus._();

  factory ParseQrStatus.success(String? uuid, String? otp) => ValidQrStatus(uuid, otp);

  factory ParseQrStatus.error(String? errorMessage) => InValidQrStatus(errorMessage);

  factory ParseQrStatus.surprise(String? proccessedUrl) => SurpriseQrStatus(proccessedUrl);
}

class ValidQrStatus extends ParseQrStatus {
  final String? uuid;
  final String? otp;

  ValidQrStatus(this.uuid, this.otp) : super._();
}

class InValidQrStatus extends ParseQrStatus {
  final String? errorMessage;

  InValidQrStatus(this.errorMessage) : super._();
}

class SurpriseQrStatus extends ParseQrStatus {
  final String? proccessedUrl;

  SurpriseQrStatus(this.proccessedUrl) : super._();
}
