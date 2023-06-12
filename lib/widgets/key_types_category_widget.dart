import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/widgets/search_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class KeyTypesCategoryWidget extends ConsumerStatefulWidget {
  const KeyTypesCategoryWidget({required this.index, super.key});

  final int index;

  @override
  ConsumerState<KeyTypesCategoryWidget> createState() => _SortCategoryWidgetState();
}

class _SortCategoryWidgetState extends ConsumerState<KeyTypesCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final searchList = ref.watch(searchFormProvider).searchRequest;
    return SearchFieldContainer(
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: searchList.isNotEmpty ? searchList[widget.index] : null,
        hint: Text(AppLocalizations.of(context)!.keyType),
        items: KeyType.values
            .map(
              (e) => DropdownMenuItem(
                value: e.name,
                child: Text(e.name.titleCase),
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
          ref.watch(filterControllerProvider.notifier).getFilteredAtData();
        },
      ),
    );
  }
}
