import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/options.dart';

class SearchForm extends ConsumerStatefulWidget {
  const SearchForm({super.key});

  @override
  ConsumerState<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends ConsumerState<SearchForm> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListTile(
        leading: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              underline: const SizedBox(),
              value: ref.watch(searchFormProvider).filter,
              items: Options.filter
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Center(child: Text(e)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  ref.watch(searchFormProvider).filter = value;
                });
              },
            ),
          ),
        ),
        title: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (String? searchRequest) async {
                ref.watch(searchFormProvider).searchRequest = searchRequest;
                await ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
              },
            ),
          ),
        ),
      ),
    );
  }
}
