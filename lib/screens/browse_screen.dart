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
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((timeStamp) async {
      ref.watch(searchFormProvider).filter[0] = Categories.sort;
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
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        iconTheme:
            Theme.of(context).iconTheme.copyWith(color: widget.textColor),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: widget.textColor),
        toolbarTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: widget.textColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: widget.appBarColor,
        title: Text(
          strings.browse,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 30,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Sizes.p27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                  strings.itemsStored,
                ),
                state.isLoading
                    ? const Expanded(child: CircularProgressIndicator())
                    : Text(
                        state.value!.length.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontSize: 10, fontWeight: FontWeight.w400),
                      )
              ],
            ),
          )
        ],
        leading: const Icon(Icons.menu),
      ),
      body: Column(
        children: [
          ...searchForms,
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              child: AtDataListWidget(state: state),
              onRefresh: () async {
                // reset atData to show all data.
                await ref.watch(atDataControllerProvider.notifier).getData();
                await ref
                    .watch(homeScreenControllerProvider.notifier)
                    .getData();
                await ref.watch(navWidgetController.notifier).getData();
              },
            ),
          )
        ],
      ),
    );
  }
}
