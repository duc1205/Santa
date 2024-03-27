import 'dart:async';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/boarding/app/ui/splash/splash_page.dart';
import 'package:santapocket/modules/system_maintenance/domain/usecases/get_running_system_maintenance_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SystemMaintenancePageViewModel extends AppViewModel {
  final GetRunningSystemMaintenanceUsecase _getRunningSystemMaintenanceUsecase;

  SystemMaintenancePageViewModel(
    this._getRunningSystemMaintenanceUsecase,
  );

  final _isShowReload = false.obs;

  bool get isShowReload => _isShowReload.value;

  StreamSubscription? _listenSystemMaintenanceConfigChange;

  @override
  void initState() {
    setReloadVisible();
    super.initState();
  }

  @override
  void disposeState() {
    _listenSystemMaintenanceConfigChange?.cancel();
    super.disposeState();
  }

  Future<Unit> setReloadVisible() async {
    await Future.delayed(const Duration(seconds: 4));
    _isShowReload.value = true;
    return unit;
  }

  Future<Unit> onCLickCheckSystemMaintenanceStatus() async {
    await showLoading();
    await run(() async {
      final runningSystemMaintenance = await _getRunningSystemMaintenanceUsecase.run();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (runningSystemMaintenance == null) {
        await Get.offAll(() => const SplashPage());
      }
    });
    await hideLoading();
    return unit;
  }
}
