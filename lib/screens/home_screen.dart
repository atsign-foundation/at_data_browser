import 'package:at_data_browser/controllers/home_screen_controller.dart';
import 'package:at_data_browser/data/authentication_repository.dart';
import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/utils/sizes.dart';
import 'package:at_data_browser/widgets/nav_widget.dart';
import 'package:at_data_browser/widgets/notification_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    var atsign = ref.watch(authenticationRepositoryProvider).getCurrentAtSign();

    var homeScreenControllerModel = ref.watch(homeScreenControllerProvider).value;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        actions: const [
          Icon(
            Icons.settings_outlined,
            color: Colors.black,
          )
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Column(children: [
                ListTile(
                  title: const Text('DataBrowser'),
                  subtitle: Text(atsign ?? ""),
                ),
                gapH64,
                NotificationListTile.notify(
                  subTitle: '${homeScreenControllerModel?.workingKeys ?? 0} keys does not require your attention',
                ),
                gapH16,
                NotificationListTile.warning(
                  subTitle: '${homeScreenControllerModel?.malformedKeys ?? 0} Keys require your attention',
                ),
                gapH64,
                SizedBox(
                  width: 343,
                  height: 63,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kBrowserColor),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Browse"),
                          Icon(Icons.search),
                        ],
                      )),
                )
              ]),
            ),
            const NavWidget(),
          ],
        ),
      ]),
    );
  }
}
