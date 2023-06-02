import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class SearchCategoryWidget extends ConsumerStatefulWidget {
  const SearchCategoryWidget({required this.index, super.key});
  final int index;
  @override
  ConsumerState<SearchCategoryWidget> createState() =>
      _SearchCategroyWidgetState();
}

class _SearchCategroyWidgetState extends ConsumerState<SearchCategoryWidget> {
  late TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.text =
        ref.watch(searchFormProvider).searchRequest[widget.index] ?? '';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.search,
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.black.withOpacity(.5), fontSize: 14),
              suffixIcon: const Icon(
                Icons.search,
                size:
                    14, //todo(kzawadi): icon size of 13.34 seems so small but that how its specified in figma document.
              ),
            ),
            onChanged: (value) {
              ref.watch(searchFormProvider).isConditionMet = [];
              ref.watch(searchFormProvider).searchRequest[widget.index] = value;
              ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
            },
          )),
    );
  }
}
