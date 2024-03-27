import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/instruction/data/repositories/instruction_repository.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetInstructionByIdUsecase extends Usecase {
  final InstructionRepository _instructionRepository;

  const GetInstructionByIdUsecase(this._instructionRepository);

  Future<Instruction> run(int id) => _instructionRepository.getInstructionById(id);
}
