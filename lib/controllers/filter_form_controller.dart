import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enums.dart';

/// A class that holds the data for the [SearchFormModel].
class SearchFormModel {
  SearchFormModel({required this.filter, required this.searchRequest, required this.isConditionMet});
  List<Categories?> filter;
  List<String?> searchRequest;
  List<bool> isConditionMet;
}

/// A provider that exposes the [SearchFormModel] to the app.
final searchFormProvider = Provider<SearchFormModel>((ref) {
  return SearchFormModel(filter: [], searchRequest: [], isConditionMet: []);
});
