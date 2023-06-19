import 'dart:developer';

import 'package:at_data_browser/controllers/at_data_controller.dart';
import 'package:at_data_browser/controllers/home_screen_controller.dart';
import 'package:at_data_browser/controllers/nav_widget_controller.dart';
import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:at_data_browser/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/filter_form_controller.dart';
import '../widgets/at_data_list_widget.dart';
import '../widgets/search_form.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  static const route = '/browse';
  const BrowseScreen(
      {this.appBarColor = kDataStorageColor,
      this.backgroundColor = kDataStorageFadedColor,
      this.textColor = Colors.black,
      super.key});

  final Color appBarColor;
  final Color backgroundColor;
  final Color textColor;

  @override
  ConsumerState<BrowseScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends ConsumerState<BrowseScreen> {
  final List<Widget> searchForms = [
    const SearchForm(
      index: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      ref.read(filterControllerProvider.notifier).getData();
      ref.read(searchFormProvider).searchRequest = [];
      ref.read(searchFormProvider).filter = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterControllerProvider);
    final searchRequest = ref.watch(searchFormProvider).searchRequest;
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: widget.textColor),
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: widget.textColor),
        toolbarTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: widget.textColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: widget.appBarColor,
        centerTitle: false,
        title: Text(
          strings.browse,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Sizes.p27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  style: Theme.of(context).textTheme.bodyMedium,
                  strings.itemsStored,
                ),
                state.isLoading
                    ? const Expanded(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: kBrowserColor,
                      ))
                    : Text(state.value!.length.toString(), style: Theme.of(context).textTheme.bodyMedium!)
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          gapH24,
          ...searchForms,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
            child: searchRequest.isNotEmpty
                ? Row(children: [
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
                        label: Text(strings.addFilter)),
                    const Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    )
                  ])
                : gapH24,
          ),
          Expanded(
            child: RefreshIndicator(
              color: kDataStorageColor,
              child: AtDataListWidget(state: state),
              onRefresh: () async {
                //reset atData to show all data.
                await ref.watch(atDataControllerProvider.notifier).getData();
                await ref.watch(homeScreenControllerProvider.notifier).getData();
                await ref.watch(navWidgetController.notifier).getData();
              },
            ),
          )
        ],
      ),
    );
  }
}
