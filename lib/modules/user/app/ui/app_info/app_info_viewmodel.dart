import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class AppInfoViewModel extends AppViewModel {
  final String fanPage = "https://www.facebook.com/SantaPocket";
  final String webSite = "https://santapocket.com";
  final String urlTerms = "https://santapocket.com/dieu-khoan-su-dung";
  final String urlPrivacy = "https://santapocket.com/chinh-sach-bao-mat";
  final String urlLockerRentalFee = "https://santapocket.com/bang-gia-thue-ngan-tu";
  final String urlGov = "http://online.gov.vn/Home/AppDetails/1794";

  String errorMessage = '';

  String getErrorMessage() => errorMessage;

  Future<Unit> openFanPage() => launchUri(fanPage);

  Future<bool> openWebsite() async {
    if (await canLaunchUrl(Uri.parse(webSite))) {
      await launchUrl(Uri.parse(webSite));
      return true;
    } else {
      errorMessage = "Could not launch website";
      return false;
    }
  }

  Future<bool> openLinkGov() async {
    if (await canLaunchUrl(Uri.parse(urlGov))) {
      await launchUrl(Uri.parse(urlGov));
      return true;
    } else {
      errorMessage = "Could not launch website";
      return false;
    }
  }

  Future<bool> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
      return true;
    } else {
      errorMessage = 'Could not call';
      return false;
    }
  }

  Future<bool> sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
      return true;
    } else {
      errorMessage = 'Could not send email';
      return false;
    }
  }
}
