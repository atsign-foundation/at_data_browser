import 'package:at_data_browser/controllers/nav_widget_controller.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:flutter/material.dart';

class NavContainer extends StatelessWidget {
  const NavContainer(
      {required this.name,
      required this.titleCount,
      required this.navWidgetModel,
      required this.color,
      required this.onTap,
      this.showIcon = false,
      this.position = NavPosition.bottom,
      super.key});

  final String name;
  final String titleCount;
  final NavWidgetModel? navWidgetModel;
  final Color color;
  final VoidCallback? onTap;
  final bool showIcon;
  final NavPosition position;

  String getCount(String titleCount) {
    switch (titleCount) {
      case 'Items Stored':
        return navWidgetModel!.dataStorageCount;

      case 'Connected atContacts':
        return navWidgetModel!.atContactsCount;

      case 'Namespaces':
        return navWidgetModel!.namespacesCount;
      default:
        return "NA";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: color,
            borderRadius: position == NavPosition.bottom
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
        child: ListTile(
          leading: showIcon ? const Icon(Icons.menu) : null,
          title: Text(name),
          trailing: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(titleCount),
                navWidgetModel == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        getCount(titleCount),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
