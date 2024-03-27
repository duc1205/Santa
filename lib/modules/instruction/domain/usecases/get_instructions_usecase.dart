import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/instruction/data/repositories/instruction_repository.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetInstructionsUsecase extends Usecase {
  final InstructionRepository _instructionRepository;

  const GetInstructionsUsecase(this._instructionRepository);

  Future<List<Instruction>> run() => _instructionRepository.getInstructions();
}
