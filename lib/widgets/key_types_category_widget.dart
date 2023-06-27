import 'dart:developer';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/widgets/search_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  String? getValue(List<String?> searchList) {
    try {
      if (searchList.isEmpty ||
          !KeyType.values.contains(KeyType.values.firstWhere((element) => element.name == searchList[widget.index]))) {
        return null;
      } else {
        return searchList[widget.index];
      }
    } on StateError {
      // searchList[widget.index] is equal to a value that is not in the KeyType enum
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchList = ref.watch(searchFormProvider).searchRequest;

    return SearchFieldContainer(
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        // only set value if searchList is not empty and items list contains a search list index
        value: getValue(searchList),
        hint: Text(AppLocalizations.of(context)!.selectKeyType),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black.withOpacity(.5),
            ),
        selectedItemBuilder: (context) => KeyType.values
            .map(
              (e) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(e.name.titleCase, style: Theme.of(context).textTheme.bodyMedium!)),
            )
            .toList(),
        items: KeyType.values
            .map(
              (e) => DropdownMenuItem(
                value: e.name,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(

                          //     color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                  child: Text(e.name.titleCase, style: Theme.of(context).textTheme.bodyMedium!),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            if (searchList.isNotEmpty) {
              searchList[widget.index] = value!;
            } else {
              searchList.add(value!);
            }
          });
          ref.watch(filterControllerProvider.notifier).getFilteredAtData();
          log('searchList: $searchList');
        },
      ),
    );
  }
}
