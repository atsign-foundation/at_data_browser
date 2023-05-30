import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/enums.dart';

class SortCategoryWidget extends ConsumerStatefulWidget {
  const SortCategoryWidget({required this.index, super.key});

  final int index;

  @override
  ConsumerState<SortCategoryWidget> createState() => _SortCategoryWidgetState();
}

class _SortCategoryWidgetState extends ConsumerState<SortCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          underline: const SizedBox(),
          value: ref.watch(searchFormProvider).searchRequest[widget.index],
          hint: Text(strings.sortBy),
          items: SortOptions.values
              .map(
                (e) => DropdownMenuItem(
                  value: e.name,
                  child: Center(
                    child: Text(e.name.titleCase),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              ref.watch(searchFormProvider).searchRequest[widget.index] = value!;
              ref.watch(filterControllerProvider.notifier).getFilteredAtData();
            });
          },
        ),
      ),
    );
  }
}
