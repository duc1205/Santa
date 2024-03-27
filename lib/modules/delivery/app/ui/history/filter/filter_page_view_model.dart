import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/shared/dialog/select_date_period_dialog.dart';

@injectable
class FilterPageViewModel extends AppViewModel {
  final _filterPeriod = Rx<DatePeriod?>(null);
  final _filterCabinet = Rx<Cabinet?>(null);

  DatePeriod? get filterPeriod => _filterPeriod.value;

  Cabinet? get filterCabinet => _filterCabinet.value;

  DateTime getStartDate() => filterPeriod?.start ?? DateTime.now();

  DateTime getEndDate() => filterPeriod?.end ?? DateTime.now();

  void onChangeCabinet(Cabinet? cabinet) => _filterCabinet.value = cabinet;

  void onChangeDateRange(DatePeriod? dateTimeRange) => _filterPeriod.value = dateTimeRange;

  String get getFilterPeriodString =>
      "${FormatHelper.formatDate("dd/MM/yyyy", filterPeriod?.start)} - ${FormatHelper.formatDate("dd/MM/yyyy", filterPeriod?.end)}";

  void onChangeCabinetFilter(Cabinet? cabinet) => _filterCabinet.value = cabinet;

  void onClearCabinetFilter() => _filterCabinet.value = null;

  void onClearPeriodFilter() => _filterPeriod.value = null;

  void showDialogDateTimeRange() {
    Get.dialog(
      SelectDatePeriodDialog(
        selectedPeriod: DatePeriod(
          getStartDate(),
          getEndDate(),
        ),
        onSaveDateRange: (period) {
          Get.back();
          onChangeDateRange(period);
        },
      ),
    );
  }

  bool canClearAll() {
    return filterPeriod != null || filterCabinet != null;
  }

  void onClearAll() {
    if (filterPeriod != null) {
      _filterPeriod.value = null;
    }
    if (filterCabinet != null) {
      _filterCabinet.value = null;
    }
  }
}
