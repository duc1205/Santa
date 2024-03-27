import 'package:get/get_rx/get_rx.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction_image.dart';
import 'package:santapocket/modules/instruction/domain/usecases/get_instruction_images_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class InstructionDetailPageViewModel extends AppViewModel {
  final GetInstructionImagesUsecase _getInstructionImagesUsecase;

  InstructionDetailPageViewModel(this._getInstructionImagesUsecase);

  final _instructionImages = Rx<List<InstructionImage>>([]);

  List<InstructionImage> get instructionImages => _instructionImages.value;

  late int instructionId;

  @override
  void initState() {
    super.initState();
    fetchData(instructionId);
  }

  Future<Unit> fetchData(int id) async {
    List<InstructionImage> tempInstructionImages = [];
    await showLoading();
    final success = await run(
      () async {
        tempInstructionImages = await _getInstructionImagesUsecase.run(id);
      },
    );
    await hideLoading();
    if (success) {
      _instructionImages.value = tempInstructionImages;
    }
    return unit;
  }
}
