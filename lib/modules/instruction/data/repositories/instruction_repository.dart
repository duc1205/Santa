import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/instruction/data/datasources/instruction_remote_datasource.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction_image.dart';

@lazySingleton
class InstructionRepository {
  final InstructionRemoteDatasource _instructionRemoteDatasource;

  InstructionRepository(this._instructionRemoteDatasource);

  Future<List<Instruction>> getInstructions() => _instructionRemoteDatasource.getInstructions();

  Future<Instruction> getInstructionById(int id) => _instructionRemoteDatasource.getInstructionById(id);

  Future<List<InstructionImage>> getInstructionImages(int id) => _instructionRemoteDatasource.getInstructionImages(id);
}
