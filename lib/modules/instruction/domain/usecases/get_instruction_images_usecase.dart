import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/instruction/data/repositories/instruction_repository.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction_image.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetInstructionImagesUsecase extends Usecase {
  final InstructionRepository _instructionRepository;

  const GetInstructionImagesUsecase(this._instructionRepository);

  Future<List<InstructionImage>> run(int id) => _instructionRepository.getInstructionImages(id);
}
