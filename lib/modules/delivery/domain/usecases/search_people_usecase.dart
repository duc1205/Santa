import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/domain/models/person.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SearchPeopleUsecase extends Usecase {
  List<Person> run({required List<Person> people, required String query}) {
    return people.where((e) => e.match(query)).toList();
  }
}
