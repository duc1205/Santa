import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/auth/app/ui/login/enter_phone_page.dart';
import 'package:santapocket/modules/user/domain/usecases/delete_account_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class DeleteAccountPageViewModel extends AppViewModel {
  final DeleteAccountUsecase _deleleAccountUsecase;
  DeleteAccountPageViewModel(this._deleleAccountUsecase);

  Future<Unit> confirmDeleteAccount() async {
    Get.back();
    await showLoading();
    final success = await run(
      () => _deleleAccountUsecase.run(),
    );
    await hideLoading();
    if (success) {
      await Get.offAll(() => const EnterPhonePage());
    }
    return unit;
  }
}
