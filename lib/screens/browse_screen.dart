import 'dart:developer';

import 'package:at_data_browser/controllers/at_data_controller.dart';
import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:at_data_browser/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/filter_form_controller.dart';
import '../widgets/at_data_list_widget.dart';
import '../widgets/search_form.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  static const route = '/browse';
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends ConsumerState<BrowseScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await ref.watch(atDataControllerProvider.notifier).getData();
    });
    super.initState();
  }

  final List<Widget> searchForms = [
    const SearchForm(
      index: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(atDataControllerProvider);
    return Scaffold(
      backgroundColor: kBrowserFadedColor,
      appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: kBrowserColor,
          title: Text(
            'Browse',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
          actions: [
            Column(
              children: [
                const Text('Items Stored'),
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(state.value!.length.toString())
              ],
            )
          ]),
      body: Column(
        children: [
          ...searchForms,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
            child: Row(children: [
              const Expanded(
                child: Divider(
                  height: 2,
                  color: Colors.black,
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      var a = searchForms.length;
                      log('search form length: is ${a.toString()}');
                      ref.watch(searchFormProvider).searchRequest.add(null);
                      ref.watch(searchFormProvider).filter.add(Categories.sort);
                      searchForms.add(SearchForm(index: searchForms.length));
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Filter')),
              const Expanded(
                child: Divider(
                  color: Colors.black,
                ),
              )
            ]),
          ),
          Expanded(
            child: AtDataListWidget(state: state),
          )
        ],
      ),
    );
  }
}
