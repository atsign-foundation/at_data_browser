import 'package:at_data_browser/screens/connected_atsigns_screen.dart';
import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/widgets/nav_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/nav_widget_controller.dart';
import '../screens/data_storage_screen.dart';

class NavWidget extends ConsumerStatefulWidget {
  const NavWidget({super.key});

  @override
  ConsumerState<NavWidget> createState() => _NavWidgetState();
}

class _NavWidgetState extends ConsumerState<NavWidget> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await ref.watch(navWidgetController.notifier).getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navWidgetModel = ref.watch(navWidgetController).value;
    return SizedBox(
      height: 225,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
            height: 225,
            child: NavContainer(
              name: 'Data Storage',
              titleCount: 'Items Stored',
              navWidgetModel: navWidgetModel,
              color: kDataStorageColor,
              onTap: () {
                Navigator.pushNamed(context, DataStorageScreen.route);
              },
            ),
          ),
          Positioned(
            height: 150,
            // top: 90,
            child: NavContainer(
              name: 'AtContacts',
              titleCount: 'Connected atContacts',
              navWidgetModel: navWidgetModel,
              color: kAtSignColor,
              onTap: () {
                Navigator.pushNamed(context, ConnectedAtsignsScreen.route);
              },
            ),
          ),
          Positioned(
            height: 75,
            child: NavContainer(
              name: 'Apps',
              titleCount: 'Namespaces',
              navWidgetModel: navWidgetModel,
              color: kAppsColor,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
