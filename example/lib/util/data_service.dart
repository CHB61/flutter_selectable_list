import 'package:example/main.dart';

class DataService {
  List<Company> allCompanies = [];
  List<Company> loadedData = [];

  DataService() {
    _initData();
  }

  void _initData() {
    if (allCompanies.isNotEmpty) return;
    int id = 1;
    for (var i = 0; i < 1000; i++) {
      Company company = Company(id: id, name: 'Company $id');
      allCompanies.add(company);
      id++;
    }
  }

  List<Company> getData({
    int limit = 25,
    int offset = 0,
  }) {
    return allCompanies.skip(offset).take(limit).toList();
  }

  Future<List<Company>> getDataAsync({
    int delay = 500,
    int limit = 25,
    int offset = 0,
    String? searchText,
  }) async {
    await Future.delayed(Duration(milliseconds: delay));
    if (searchText != null && searchText.isNotEmpty) {
      return allCompanies
          .where((e) => e.name.toLowerCase().contains(searchText.toLowerCase()))
          .skip(offset)
          .take(limit)
          .toList();
    }
    return allCompanies.skip(offset).take(limit).toList();
  }
}
