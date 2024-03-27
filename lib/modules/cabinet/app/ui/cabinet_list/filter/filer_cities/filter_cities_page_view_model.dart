import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_cities_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class FilterCitiesPageViewModel extends AppViewModel {
  final GetCabinetCitiesUsecase _getCabinetCitiesUseCase;

  FilterCitiesPageViewModel(this._getCabinetCitiesUseCase);

  final _cities = RxList<String>([]);
  final _filterCity = Rx<String>("");

  List<String> get cities => _cities.toList();

  String get selectedCity => _filterCity.value;

  void setSelectedCity(String city) {
    _filterCity.value = city;
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
    late List<String> currentCity;
    await showLoading();
    final success = await run(
      () async {
        currentCity = await _getCabinetCitiesUseCase.run();
      },
    );
    await hideLoading();
    if (success) {
      _cities.value += currentCity;
    }
    return unit;
  }

  void onRefresh() {
    _fetchData();
  }
}
