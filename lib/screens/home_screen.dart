import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/controllers/home_screen_controller.dart';
import 'package:at_data_browser/data/authentication_repository.dart';
import 'package:at_data_browser/screens/settings_screen.dart';
import 'package:at_data_browser/utils/sizes.dart';
import 'package:at_data_browser/widgets/nav_widget.dart';
import 'package:at_data_browser/widgets/notification_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';
import '../utils/enums.dart';
import 'browse_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await ref.read(atDataControllerProvider.notifier).getData();
      // await ref.read(homeScreenControllerProvider.notifier).getData();
    });
    super.initState();
  }

  /// Navigate to screen to see invalid keys.
  Future<void> _navigateToInvalidKey() async {
    // set the search request to the selected app
    try {
      ref.watch(searchFormProvider).searchRequest[0] = KeyType.invalidKey.name;
    } on RangeError {
      ref.watch(searchFormProvider).searchRequest.add(KeyType.invalidKey.name);
    }

    // set the filter to apps
    try {
      ref.watch(searchFormProvider).filter[0] = Categories.keyTypes;
    } on RangeError {
      ref.watch(searchFormProvider).filter.add(Categories.keyTypes);
    }

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BrowseScreen(
            appBarColor: Color(0Xff57A8B5),
            textColor: Colors.black,
            isResetSearchForm: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final atsign = ref.watch(authenticationRepositoryProvider).getCurrentAtSign();
    final strings = AppLocalizations.of(context)!;
    var homeScreenControllerModel = ref.watch(homeScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: Colors.black,
              iconSize: 40,
              onPressed: () {
                Navigator.of(context).pushNamed(SettingsScreen.route);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(children: [
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        'Data',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        'Browser',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(atsign ?? ''),
                ),
              ),
              gapH64,
              NotificationListTile.notify(
                subTitle: strings.validKeyMessage(homeScreenControllerModel.asData?.value.workingKeys.length ?? 0),
              ),
              gapH16,
              GestureDetector(
                onTap: () async => _navigateToInvalidKey(),
                child: NotificationListTile.warning(
                  subTitle:
                      strings.invalidKeyMessage(homeScreenControllerModel.asData?.value.malformedKeys.length ?? 0),
                ),
              ),
            ]),
          ),
          const NavWidget(),
        ],
      ),
    );
  }
}
