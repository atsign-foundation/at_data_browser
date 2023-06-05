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

    return SearchFieldContainer(
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: searchList.isNotEmpty ? searchList[widget.index] : null,
        hint: Text(AppLocalizations.of(context)!.apps),
        items: ref
            .watch(atDataControllerProvider.notifier.select((value) => value.apps))
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
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
        },
      ),
    );
  }
}
