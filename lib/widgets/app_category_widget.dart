import 'package:at_data_browser/controllers/apps_controller.dart';
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          underline: const SizedBox(),
          value: ref.watch(searchFormProvider).searchRequest[widget.index],
          hint: Text(AppLocalizations.of(context)!.apps),
          items: ref
              .watch(appsController)
              .value
              ?.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              ref.watch(searchFormProvider).searchRequest[widget.index] = value!;
            });

            // filter atData by conditions set in searchFormProvider
            ref.watch(filterControllerProvider.notifier).getFilteredAtData();
          },
        ),
      ),
    );
  }
}
