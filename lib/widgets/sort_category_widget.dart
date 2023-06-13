import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

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
    final searchList = ref.watch(searchFormProvider).searchRequest;
    final strings = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          underline: const SizedBox(),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          value: ref.watch(searchFormProvider).searchRequest[widget.index],
          hint: Text(strings.sortBy),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.black.withOpacity(.5), fontSize: 14),
          items: SortOptions.values
              .map(
                (e) => DropdownMenuItem(
                  value: e.name,
                  child: Center(
                    child: Text(
                      e.name.titleCase,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              ref.watch(searchFormProvider).searchRequest[widget.index] =
                  value!;
              // ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
            });
          },
        ),
      ),
    );
  }
}
