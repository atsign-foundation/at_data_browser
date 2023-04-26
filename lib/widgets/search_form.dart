import 'dart:developer';

import 'package:at_data_browser/widgets/app_category_widget.dart';
import 'package:at_data_browser/widgets/data_range_category_widget.dart';
import 'package:at_data_browser/widgets/search_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../controllers/apps_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/enums.dart';
import 'keyTypes_category_widget.dart';
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
    switch (category) {
      case Categories.sort:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return SortCategoryWidget(
          index: widget.index,
        );
      case Categories.contains:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.dateCreated:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return DateRangeCategoryWidget(
          labelText: 'Date Range',
          index: widget.index,
        );
      case Categories.dateModified:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return DateRangeCategoryWidget(
          labelText: 'Date Range',
          index: widget.index,
        );
      case Categories.apps:
        // ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        Future(
          () async {
            await ref.read(appsController.notifier).getData();
          },
        );

        return AppCategoryWidget(index: widget.index);
      case Categories.atsign:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.keyTypes:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return KeyTypesCategoryWidget(
          index: widget.index,
        );
      case Categories.sharedWith:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.sharedBy:
        ref.watch(searchFormProvider).searchRequest[widget.index] = null;
        return SearchCategoryWidget(
          index: widget.index,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<Categories>(
                  underline: const SizedBox(),
                  value: ref.watch(searchFormProvider).filter[widget.index]!,
                  hint: const Text('Category'),
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
                      ref.watch(searchFormProvider).filter[widget.index] = value!;
                      log(ref.watch(searchFormProvider).filter[widget.index]?.name ?? 'null');
                      log(ref.watch(searchFormProvider).filter.length.toString());
                      log('search form index is ${widget.index.toString()}');
                    });
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder(
                builder: (context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else {
                    return const SizedBox();
                  }
                },
                future: getCategoryWidget(ref.watch(searchFormProvider).filter[widget.index]!)),
          ),
        ],
      ),
    );
  }
}
