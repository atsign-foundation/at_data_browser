import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFormModel {
  SearchFormModel({this.filter, this.searchRequest});
  String? filter;
  String? searchRequest;
}

final searchFormProvider = Provider<SearchFormModel>((ref) {
  return SearchFormModel();
});
