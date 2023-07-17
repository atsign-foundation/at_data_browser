import 'package:at_data_browser/controllers/nav_widget_controller.dart';
import 'package:at_data_browser/utils/constants.dart';
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
      this.height = 100,
      super.key});

  final String name;
  final String titleCount;
  final NavWidgetModel? navWidgetModel;
  final Color color;
  final VoidCallback? onTap;
  final bool showIcon;
  final NavPosition position;
  final double height;

  String getCount(String titleCount) {
    switch (titleCount) {
      case 'Items Stored':
        return navWidgetModel!.dataStorageCount;

      case 'Connected\natSigns':
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
          height: height,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        titleCount,
                        style: const TextStyle(
                            // fontSize: 20,
                            ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      navWidgetModel == null
                          ? SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                color: kBrowserColor,
                                backgroundColor: color,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              getCount(titleCount),
                              style: const TextStyle(
                                // fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
