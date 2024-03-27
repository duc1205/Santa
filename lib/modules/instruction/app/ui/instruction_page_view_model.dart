import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:santapocket/modules/instruction/domain/usecases/get_instructions_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class InstructionPageViewModel extends AppViewModel {
  final GetInstructionsUsecase _getInstructionUsecase;

  InstructionPageViewModel(this._getInstructionUsecase);

  final _instruction = Rx<List<Instruction>>([]);

  List<Instruction> get instructions => _instruction.value;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<Unit> fetchData() async {
    List<Instruction> tempInstruction = [];
    await showLoading();
    final success = await run(
      () async {
        tempInstruction = await _getInstructionUsecase.run();
      },
    );
    await hideLoading();
    if (success) {
      _instruction.value = tempInstruction;
    }
    return unit;
  }
}
