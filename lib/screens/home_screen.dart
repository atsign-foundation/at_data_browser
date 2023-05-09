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
      await ref.watch(homeScreenControllerProvider.notifier).getData();
    });
    super.initState();
  }

  Future<void> _navigateToInvaldKey() async {
    // set the search request to the selected app
    ref.watch(searchFormProvider).searchRequest[0] = KeyType.invalidKey.name;
    // set the filter to apps
    ref.watch(searchFormProvider).filter[0] = Categories.keyTypes;
    // filter atData by conditions set in searchFormProvider
    await ref.watch(atDataControllerProvider.notifier).getFilteredAtData();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BrowseScreen(
          appBarColor: Colors.white,
          textColor: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final atsign = ref.watch(authenticationRepositoryProvider).getCurrentAtSign();
    final strings = AppLocalizations.of(context)!;

    var homeScreenControllerModel = ref.watch(homeScreenControllerProvider).value;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.route);
            },
          ),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Column(children: [
                ListTile(
                  title: Text(strings.atDataBrowser),
                  subtitle: Text(atsign ?? ""),
                ),
                gapH64,
                NotificationListTile.notify(
                  subTitle: '${homeScreenControllerModel?.workingKeys.length ?? 0} ${strings.validKeyMessage}',
                ),
                gapH16,
                GestureDetector(
                  onTap: () async => _navigateToInvaldKey(),
                  child: NotificationListTile.warning(
                    subTitle: '${homeScreenControllerModel?.malformedKeys.length ?? 0} ${strings.invalidKeyMessage}',
                  ),
                ),
                gapH64,
              ]),
            ),
            const NavWidget(),
          ],
        ),
      ]),
    );
  }
}