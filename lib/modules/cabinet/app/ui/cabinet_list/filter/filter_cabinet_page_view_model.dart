import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';

@injectable
class FilterCabinetPageViewModel extends AppViewModel {
  final _filterCity = Rx<String>("");
  final _filterDistrict = Rx<String>("");

  String get filterDistrict => _filterDistrict.value;

  String get filterCity => _filterCity.value;

  void onChangeCity(String city) => _filterCity.value = city;

  void onChangeDistrict(String district) => _filterDistrict.value = district;

  void onClearCityFilter() => _filterCity.value = "";

  void onClearDistrictFilter() => _filterDistrict.value = "";

  void onClearAll() {
    onClearCityFilter();
    onClearDistrictFilter();
  }

  bool canClearAll() {
    return filterDistrict.isNotEmpty || filterCity.isNotEmpty;
  }
}
