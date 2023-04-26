import 'package:at_data_browser/controllers/apps_controller.dart';
import 'package:at_data_browser/screens/browse_screen.dart';
import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:at_data_browser/widgets/apps_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appsController);
    return Scaffold(
      backgroundColor: kAppsFadedColor,
      appBar: AppBar(
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
          toolbarTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: kAppsColor,
          title: const Text('Apps'),
          actions: [
            Column(
              children: [
                const Text('Connected Apps'),
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(state.value!.length.toString())
              ],
            )
          ]),
      body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              const AppsSearchWidget(),
              Expanded(child: Builder(
                builder: (BuildContext context) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Card(
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
                              onTap: () async {
                                // set the search request to the selected app
                                ref.watch(searchFormProvider).searchRequest[0] = state.value![index];
                                // set the filter to apps
                                ref.watch(searchFormProvider).filter[0] = Categories.apps;
                                // filter atData by conditions set in searchFormProvider
                                await ref.watch(atDataControllerProvider.notifier).getFilteredAtData();

                                await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const BrowseScreen(
                                          appBarColor: Colors.white,
                                          backgroundColor: kAppsFadedColor,
                                          textColor: Colors.black,
                                        )));
                              },
                            ),
                            Divider(
                              color: Colors.grey.withOpacity(0.2),
                            )
                          ],
                        ),
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
