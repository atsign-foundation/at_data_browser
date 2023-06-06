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

      case 'Connected atSigns':
        return navWidgetModel!.atContactsCount;

      case 'Connected Apps':
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
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: color,
            borderRadius: position == NavPosition.bottom
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
        child: ListTile(
          leading: showIcon ? const Icon(Icons.menu) : null,
          title: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                name, 
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                  ),
                ),
              ),
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
