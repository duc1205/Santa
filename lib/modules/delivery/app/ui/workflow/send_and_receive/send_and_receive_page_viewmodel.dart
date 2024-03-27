import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send/send_package_info_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_packages_page.dart';

@injectable
class SendAndReceivePageViewModel extends AppViewModel {
  late CabinetInfo cabinetInfo;

  void onClickButtonSend() => Get.to(
        () => SendPackageInfoPage(cabinetInfo: cabinetInfo),
      );

  void onClickButtonReceive() => Get.to(
        () => ReceivePackagesPage(
          cabinetInfo: cabinetInfo,
        ),
      );
}
