import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enums.dart';

class SearchFormModel {
  SearchFormModel({required this.filter, required this.searchRequest, required this.isConditionMet});
  List<Categories?> filter;
  List<String?> searchRequest;
  List<bool> isConditionMet;
}

final searchFormProvider = Provider<SearchFormModel>((ref) {
  return SearchFormModel(filter: [Categories.sort], searchRequest: [null], isConditionMet: []);
});
