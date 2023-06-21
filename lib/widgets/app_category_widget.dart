import 'dart:developer';

import 'package:at_data_browser/widgets/search_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class AppCategoryWidget extends ConsumerStatefulWidget {
  const AppCategoryWidget({required this.index, super.key});

  final int index;

  @override
  ConsumerState<AppCategoryWidget> createState() => _SortCategoryWidgetState();
}

class _SortCategoryWidgetState extends ConsumerState<AppCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final searchList = ref.watch(searchFormProvider).searchRequest;
    log('search list state:$searchList');
    log('search list is empty:${searchList.isEmpty} ');
    return SearchFieldContainer(
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        // only set value if searchList is not empty and searchList contains a value found in the items list
        value: searchList.isEmpty ||
                !ref
                    .watch(atDataControllerProvider.notifier.select((value) => value.apps))
                    .contains(searchList[widget.index])
            ? null
            : searchList[widget.index],
        hint: Text(AppLocalizations.of(context)!.selectNamespaces),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black.withOpacity(.5),
            ),
        selectedItemBuilder: (context) => ref
            .watch(atDataControllerProvider.notifier.select((value) => value.apps))
            .map(
              (e) => Align(
                  alignment: Alignment.centerLeft, child: Text(e, style: Theme.of(context).textTheme.bodyMedium!)),
            )
            .toList(),
        items: ref
            .watch(atDataControllerProvider.notifier.select((value) => value.apps))
            .map(
              (e) => DropdownMenuItem(
                value: e,
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
                  child: Text(e, style: Theme.of(context).textTheme.bodyMedium!),
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

          // filter atData by conditions set in searchFormProvider
          ref.watch(filterControllerProvider.notifier).getFilteredAtData();
          log('searchList: $searchList');
        },
      ),
    );
  }
}
