import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_districts_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class FilterDistrictsPageViewModel extends AppViewModel {
  final GetCabinetDistrictsUsecase _getCabinetDistrictsUsecase;

  FilterDistrictsPageViewModel(this._getCabinetDistrictsUsecase);

  final _districts = RxList<String>([]);
  final _filterDistrict = Rx<String>("");

  List<String> get districts => _districts.toList();

  String get selectedDistrict => _filterDistrict.value;

  String selectedCity = "";

  void setSelectedDistrict(String district) {
    _filterDistrict.value = district;
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<Unit> _initData() async {
    await showLoading();
    await _fetchData();
    await hideLoading();
    return unit;
  }

  Future<Unit> _fetchData() async {
    late List<String> currentDistrict;
    await showLoading();
    final success = await run(
      () async {
        currentDistrict = await _getCabinetDistrictsUsecase.run(city: selectedCity);
      },
    );
    await hideLoading();
    if (success) {
      _districts.value += currentDistrict;
    }
    return unit;
  }

  void onRefresh() {
    _fetchData();
  }
}
