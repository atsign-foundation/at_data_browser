import 'package:at_data_browser/widgets/search_field_container.dart';
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
    final searchList = ref.watch(searchFormProvider).searchRequest;
    final strings = AppLocalizations.of(context)!;
    return SearchFieldContainer(
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        value: searchList.isNotEmpty ? searchList[widget.index] : null,
        hint: Text(strings.sortBy),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black.withOpacity(.5),
            ),
        items: SortOptions.values
            .map(
              (e) => DropdownMenuItem(
                value: e.name,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.name.titleCase, style: Theme.of(context).textTheme.bodyMedium!),
                      Icon(e == SortOptions.ascending ? Icons.north : Icons.south)
                    ],
                  ),
                ),
              ),
              //
              // DropdownMenuItem(
              //   value: e.name,
              //   child: Padding(
              //     padding: EdgeInsets.zero,
              //     child: Center(
              //       child: Text(
              //         e.name.titleCase,
              //         style: Theme.of(context).textTheme.bodyMedium!,
              //       ),
              //     ),
              //   ),
              // ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            if (searchList.isNotEmpty) {
              searchList[widget.index] = value!;
            } else {
              searchList.add(value!);
            }
            ref.watch(filterControllerProvider.notifier).getFilteredAtData();
          });
        },
      ),
    );
  }
}
