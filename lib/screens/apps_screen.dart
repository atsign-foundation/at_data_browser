import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/apps_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../widgets/search_widget.dart';
import 'browse_screen.dart';

class AppsScreen extends ConsumerStatefulWidget {
  static const route = '/atsigns';
  const AppsScreen({super.key});

  @override
  ConsumerState<AppsScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends ConsumerState<AppsScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await ref.watch(appsController.notifier).getData();
    });
    super.initState();
  }

  /// Navigate to browse screen showing atkeys filtered by the selected apps.
  Future<void> _onTap({required AsyncValue<List<String>> state, required int index}) async {
    // set the search request to the selected app
    try {
      ref.watch(searchFormProvider).searchRequest[0] = state.value![index];
      log('search request is: ${ref.read(searchFormProvider).searchRequest}');
    } on RangeError {
      ref.watch(searchFormProvider).searchRequest.add(state.value![index]);
      log('search request is: ${ref.read(searchFormProvider).searchRequest}');
    }
    // set the filter to apps
    try {
      ref.watch(searchFormProvider).filter[0] = Categories.namespaces;
    } on RangeError {
      ref.watch(searchFormProvider).filter.add(Categories.namespaces);
    }

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BrowseScreen(
            textColor: Colors.black,
            isResetSearchForm: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appsController);
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kAppsFadedColor,
      appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          titleTextStyle: Theme.of(context).textTheme.titleLarge!,
          toolbarTextStyle: Theme.of(context).textTheme.titleMedium!,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: kAppsColor,
          title: Text(strings.apps),
          actions: [
            FittedBox(
              child: Column(
                children: [
                  Text(strings.connectedApps),
                  state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(state.value!.length.toString())
                ],
              ),
            )
          ]),
      body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              const SearchWidget(
                filter: SearchWidgetFilter.apps,
              ),
              Expanded(child: Builder(
                builder: (BuildContext context) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return state.value!.isNotEmpty
                        ? Card(
                            margin: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                            child: ListView.builder(
                              itemCount: state.value!.length,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  GestureDetector(
                                    child: ListTile(
                                      title: Text(state.value![index]),
                                    ),
                                    onTap: () => _onTap(state: state, index: index),
                                  ),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.2),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Card(
                            margin: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Image(
                                  image: AssetImage('assets/images/empty.png'),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.noNamespaces,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: Colors.grey, fontSize: 40),
                                ),
                              ]),
                            ),
                          );
                  }
                },
              ))
            ],
          )),
    );
  }
}
