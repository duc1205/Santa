import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/delivery/domain/models/person.dart';
import 'package:santapocket/modules/delivery/domain/usecases/search_people_usecase.dart';

@injectable
class ContactsPageViewModel extends AppViewModel {
  final SearchPeopleUsecase _searchPeopleUsecase;

  ContactsPageViewModel(this._searchPeopleUsecase);

  late TextEditingController controller;

  final _listPersons = Rx<List<Person>>([]);
  final _dataFind = Rx<List<Person>>([]);
  final _selectedIndex = Rx<int>(-1);
  final _query = Rx<String>("");

  int get selectedIndex => _selectedIndex.value;

  String get query => _query.value;

  List<Person> get listPersons => _listPersons.value;

  List<Person> get dataFind => _dataFind.value;

  void loadArguments(List<Person> persons) {
    _listPersons(persons);
    _dataFind(persons);
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void disposeState() {
    controller.dispose();
    super.initState();
  }

  void findContact() {
    _listPersons.value = _searchPeopleUsecase.run(query: query, people: dataFind);
  }

  void onChangeText(String text) {
    _query(text.trim());
    _selectedIndex(-1);
    findContact();
  }

  void onClearQueryText() {
    controller.clear();
    _query("");
    findContact();
  }

  void onItemClick(int index) => _selectedIndex(index);
}
