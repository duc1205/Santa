import 'package:get/get.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/main/app/ui/home/enums/action_scan.dart';
import 'package:santapocket/modules/main/app/ui/main_page_viewmodel.dart';
import 'package:santapocket/modules/main/app/ui/widgets/qr_scanner_page.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/oauth2/oauth2_manager.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

class ShortcutsManager {
  static const String scanCabinet = 'SCAN_CABINET';
  static const String sendDelivery = 'SEND_DELIVERY';
  static const String receiveDelivery = 'RECEIVE_DELIVERY';
  static const String rentDelivery = 'RENT_DELIVERY';

  static final ShortcutsManager instance = ShortcutsManager._internal();

  ShortcutsManager._internal();

  final QuickActions _quickActions = const QuickActions();

  MainPageViewModel? viewModel;

  void initialShortcutActions(MainPageViewModel viewModel) {
    this.viewModel = viewModel;
    _quickActions.initialize((type) {
      _handleShortcuts(shortcutType: type);
    });
    _quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(type: scanCabinet, localizedTitle: LocaleKeys.shared_scan_cabinet.trans(), icon: 'ic_scan'),
      ShortcutItem(type: sendDelivery, localizedTitle: LocaleKeys.shared_send_delivery.trans(), icon: 'ic_driver'),
      ShortcutItem(type: receiveDelivery, localizedTitle: LocaleKeys.shared_receive_delivery.trans(), icon: 'ic_receive_rounded'),
      ShortcutItem(type: rentDelivery, localizedTitle: LocaleKeys.shared_rent_pocket.trans(), icon: 'ic_rent_rounded'),
    ]);
  }

  onScanButtonPressed(ActionScan action) async {
    final barcode = await Get.to(
      () => const QRScannerPage(),
    );
    if (barcode != null) {
      await viewModel?.handleQrCodeData(barcode: barcode as String, scan: action);
    }
  }

  Future<Unit> _handleShortcuts({required String shortcutType}) async {
    final isAuth = await Oauth2Manager.instance.checkAuth();
    if (!isAuth) return unit;
    final user = await locator<GetProfileUsecase>().run();
    if (user.shouldWizardName || user.shouldWizardType || !user.isCompletedTutorial) return unit;
    switch (shortcutType) {
      case scanCabinet:
        {
          onScanButtonPressed(ActionScan.scan);
          break;
        }
      case sendDelivery:
        {
          onScanButtonPressed(ActionScan.send);
          break;
        }
      case receiveDelivery:
        {
          onScanButtonPressed(ActionScan.receive);
          break;
        }
      case rentDelivery:
        {
          onScanButtonPressed(ActionScan.selfRent);
          break;
        }
    }
    return unit;
  }

  void removeAllShortcut() => _quickActions.clearShortcutItems();
}
