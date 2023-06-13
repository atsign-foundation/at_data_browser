import 'dart:developer';

import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/widgets/app_category_widget.dart';
import 'package:at_data_browser/widgets/data_range_category_widget.dart';
import 'package:at_data_browser/widgets/search_category_widget.dart';
import 'package:at_data_browser/widgets/sort_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../controllers/apps_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/enums.dart';
import 'key_types_category_widget.dart';

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
      case Categories.contains:
        return SearchCategoryWidget(
          index: widget.index,
        );
      case Categories.sort:
        return SortCategoryWidget(
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
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 14, left: 15),
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: Card(
                color: kCardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(
                    color: kCardColor,
                    width: 2,
                  ),
                ),
                child: DropdownButtonFormField<Categories>(
                  value: ref.watch(searchFormProvider).filter[widget.index]!,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  selectedItemBuilder: (context) => Categories.values
                      .map(
                        (e) => Center(
                            child: Text(
                          e.name.titleCase,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12),
                        )),
                      )
                      .toList(),
                  items: Categories.values
                      .map(
                        (e) => DropdownMenuItem<Categories>(
                          value: e,
                          child: Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  e.name.titleCase,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    log('dropdown value is ${value.toString()}');
                    setState(() {
                      ref.watch(searchFormProvider).filter[widget.index] =
                          value!;
                      log(ref
                              .watch(searchFormProvider)
                              .filter[widget.index]
                              ?.name ??
                          'null');
                      log(ref
                          .watch(searchFormProvider)
                          .filter
                          .length
                          .toString());
                      log('search form index is ${widget.index.toString()}');
                    });
                  },
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: FutureBuilder(
                  builder: (context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return const SizedBox();
                    }
                  },
                  future: getCategoryWidget(
                      ref.watch(searchFormProvider).filter[widget.index]!)),
            ),
          ],
        ),
      ),
    );
  }
}
