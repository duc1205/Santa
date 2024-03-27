import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction_image.dart';

part 'instruction_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/instructions")
abstract class InstructionService {
  @factoryMethod
  factory InstructionService(Dio dio) = _InstructionService;

  @GET("")
  Future<List<Instruction>> getInstructions({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("q") String? q,
    @Query("search_limit") String? searchLimit,
  });

  @GET("/id/{id}")
  Future<Instruction> getInstructionById(@Path("id") int id);

  @GET("/images")
  Future<List<InstructionImage>> getInstructionImages({
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("q") String? q,
    @Query("search_limit") String? searchLimit,
    @Query("instruction_id") int? instructionId,
  });
}
