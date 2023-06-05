import 'dart:developer';

import 'package:at_data_browser/utils/sizes.dart';
import 'package:at_data_browser/widgets/app_category_widget.dart';
import 'package:at_data_browser/widgets/data_range_category_widget.dart';
import 'package:at_data_browser/widgets/search_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../controllers/apps_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/enums.dart';
import 'key_types_category_widget.dart';
import 'search_field_container.dart';
import 'sort_category_widget.dart';

class SearchForm extends ConsumerStatefulWidget {
  const SearchForm({
    required this.index,
    super.key,
  });
  final int index;

  @override
  ConsumerState<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends ConsumerState<SearchForm> {
  Future<Widget> getCategoryWidget(Categories category) async {
    // clear search request
    final searchRequest = ref.watch(searchFormProvider).searchRequest;

    // clear search request
    if (searchRequest.isNotEmpty) {
      searchRequest[widget.index] = null;
    }

    switch (category) {
      case Categories.sort:
        return SortCategoryWidget(
          index: widget.index,
        );
      case Categories.contains:
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.dateCreated:
        return DateRangeCategoryWidget(
          labelText: 'Date Range',
          index: widget.index,
        );
      case Categories.dateModified:
        return DateRangeCategoryWidget(
          labelText: 'Date Range',
          index: widget.index,
        );
      case Categories.apps:
        Future(
          () async {
            await ref.read(appsController.notifier).getData();
          },
        );

        return AppCategoryWidget(index: widget.index);
      case Categories.atsign:
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.keyTypes:
        return KeyTypesCategoryWidget(
          index: widget.index,
        );
      case Categories.sharedWith:
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.sharedBy:
        return SearchCategoryWidget(
          index: widget.index,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterList = ref.watch(searchFormProvider).filter;
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.98,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SearchFieldContainer(
            child: DropdownButton<Categories>(
              isExpanded: true,
              underline: const SizedBox(),
              value: filterList.isNotEmpty ? filterList[widget.index] : null,
              hint: Text(AppLocalizations.of(context)!.category),
              items: Categories.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Center(child: Text(e.name.titleCase)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                log('dropdown value is ${value.toString()}');
                setState(() {
                  if (filterList.isNotEmpty) {
                    filterList[widget.index] = value!;
                  } else {
                    filterList.add(value!);
                  }
                  // ref.watch(searchFormProvider).filter[widget.index] = value!;
                  log(filterList[widget.index]?.name ?? 'null');
                  log(filterList.length.toString());
                  log('search form index is ${widget.index.toString()}');
                });
              },
            ),
          ),
          gapW12,
          Expanded(
            child: filterList.isNotEmpty
                ? FutureBuilder(
                    builder: (context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return const SizedBox();
                      }
                    },
                    future: getCategoryWidget(ref.watch(searchFormProvider).filter[widget.index]!),
                  )
                : const SearchCategoryWidget(index: 0),
          ),
        ],
      ),
    );
  }
}
