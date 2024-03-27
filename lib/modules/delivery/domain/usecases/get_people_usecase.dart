import 'package:collection/collection.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/modules/delivery/domain/enums/person_source.dart';
import 'package:santapocket/modules/delivery/domain/models/person.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetPeopleUsecase extends Usecase {
  Future<List<Person>> run() async {
    return _getContacts();
  }

  Future<List<Person>> _getContacts() async {
    final PermissionStatus permissionContact = await Permission.contacts.status;
    if (permissionContact.isGranted) {
      return (await ContactsService.getContacts(withThumbnails: false))
          .where((e) => e.phones != null && e.phones!.isNotEmpty && e.phones![0].value != null)
          .map(
            (e) => Person(
              name: e.displayName,
              phoneNumber: e.phones![0].value!,
              source: PersonSource.contact,
            ),
          )
          .sorted((a, b) => (a.name ?? a.phoneNumber).toLowerCase().compareTo((b.name ?? b.phoneNumber).toLowerCase()))
          .toList();
    }
    return [];
  }
}
