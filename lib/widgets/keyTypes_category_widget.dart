import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class KeyTypesCategoryWidget extends ConsumerStatefulWidget {
  const KeyTypesCategoryWidget({required this.index, super.key});

  final int index;

  @override
  ConsumerState<KeyTypesCategoryWidget> createState() => _SortCategoryWidgetState();
}

class _SortCategoryWidgetState extends ConsumerState<KeyTypesCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          isExpanded: true,
          underline: const SizedBox(),
          value: ref.watch(searchFormProvider).searchRequest[widget.index],
          hint: const Text('Key Type'),
          items: KeyType.values
              .map(
                (e) => DropdownMenuItem(
                  value: e.name,
                  child: Text(e.name.titleCase),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              ref.watch(searchFormProvider).searchRequest[widget.index] = value!;
            });
            ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
          },
        ),
      ),
    );
  }
}
