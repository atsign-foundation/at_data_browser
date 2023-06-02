import 'dart:developer';

import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/widgets/app_category_widget.dart';
import 'package:at_data_browser/widgets/data_range_category_widget.dart';
import 'package:at_data_browser/widgets/search_category_widget.dart';
import 'package:at_data_browser/widgets/sort_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    ref.watch(searchFormProvider).searchRequest[widget.index] = null;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Card(
                color: kCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: kCardColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<Categories>(
                      underline: const SizedBox.shrink(),
                      value:
                          ref.watch(searchFormProvider).filter[widget.index]!,
                      hint: Text(AppLocalizations.of(context)!.category),
                      borderRadius: BorderRadius.circular(5),
                      icon: const RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 15,
                        ),
                      ),
                      style: Theme.of(context).textTheme.labelMedium,
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
              ),
            ),
            Flexible(
              flex: 2,
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
