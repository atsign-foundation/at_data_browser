import 'dart:developer';

import 'package:at_data_browser/widgets/search_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class SearchCategoryWidget extends ConsumerStatefulWidget {
  const SearchCategoryWidget({required this.index, this.readOnly = false, super.key});
  final int index;
  final bool readOnly;
  @override
  ConsumerState<SearchCategoryWidget> createState() => _SearchCategoryWidgetState();
}

class _SearchCategoryWidgetState extends ConsumerState<SearchCategoryWidget> {
  TextEditingController textEditingController = TextEditingController();

  bool showClearIcon = false;

  @override
  void dispose() {
    textEditingController.dispose();

    super.dispose();
  }

  Widget searchIcon = IconButton(onPressed: () {}, icon: const Icon(Icons.search));

  @override
  Widget build(BuildContext context) {
    final searchRequest = ref.watch(searchFormProvider).searchRequest;
    // set the text in the search field to the value in the search request if the search request is not empty

    if (searchRequest.isNotEmpty && searchRequest[widget.index] != null) {
      log('searchRequest is not empty: ${searchRequest[widget.index]}');
      textEditingController.text = searchRequest[widget.index]!;
    } else {
      log('searchRequest is empty');
      // searchRequest.add('');
      log(searchRequest.toString());
      textEditingController.text = '';
    }

    return SearchFieldContainer(
      child: TextField(
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          // contentPadding: const EdgeInsets.all(Sizes.p8),
          // isCollapsed: true,
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.search,
          // alignLabelWithHint: true,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black.withOpacity(.5),
              ),
          suffixIcon: showClearIcon
              ? IconButton(
                  onPressed: () {
                    textEditingController.clear();
                  },
                  icon: const Icon(Icons.clear),
                )
              : const Icon(Icons.search),
        ),
        controller: textEditingController,
        onChanged: (value) {
          ref.watch(searchFormProvider).isConditionMet = [];
          if (searchRequest.isNotEmpty) {
            searchRequest[widget.index] = value;
          } else {
            searchRequest.add(value);
          }
          searchRequest[widget.index] = value;
          ref.watch(filterControllerProvider.notifier).getFilteredAtData();
          log('searchRequest: $searchRequest');
        },
        onTap: () {
          if (!widget.readOnly && !showClearIcon) {
            setState(() {
              showClearIcon = true;
            });
          }
        },
      ),
    );
  }
}
