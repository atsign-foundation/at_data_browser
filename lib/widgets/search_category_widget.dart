import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class SearchCategoryWidget extends ConsumerStatefulWidget {
  const SearchCategoryWidget({required this.index, super.key});
  final int index;
  @override
  ConsumerState<SearchCategoryWidget> createState() => _SearchCategroyWidgetState();
}

class _SearchCategroyWidgetState extends ConsumerState<SearchCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              ref.watch(searchFormProvider).isConditionMet = [];
              ref.watch(searchFormProvider).searchRequest[widget.index] = value;
              ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
            },
          )),
    );
  }
}
