import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/detail/hrm_payroll_detail_page.dart';

@injectable
class HrmPayrollSuccessPageViewmodel extends AppViewModel {
  onGetStartClicked() {
    Get.off(() => const HrmPayrollDetailPage());
  }
}
