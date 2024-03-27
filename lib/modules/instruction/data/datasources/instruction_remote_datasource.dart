import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/instruction/data/datasources/services/instruction_service.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction_image.dart';

abstract class InstructionRemoteDatasource {
  Future<List<Instruction>> getInstructions();

  Future<Instruction> getInstructionById(int id);

  Future<List<InstructionImage>> getInstructionImages(int id);
}

@LazySingleton(as: InstructionRemoteDatasource)
class InstructionRemoteDatasourceImpl extends InstructionRemoteDatasource {
  final InstructionService _instructionService;

  InstructionRemoteDatasourceImpl(this._instructionService);

  @override
  Future<Instruction> getInstructionById(int id) {
    return _instructionService.getInstructionById(id);
  }

  @override
  Future<List<Instruction>> getInstructions() {
    return _instructionService.getInstructions();
  }

  @override
  Future<List<InstructionImage>> getInstructionImages(int id) => _instructionService.getInstructionImages(instructionId: id);
}
