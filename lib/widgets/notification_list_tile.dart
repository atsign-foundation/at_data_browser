import 'package:flutter/material.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    Key? key,
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.color,
    required this.subTitle,
  }) : super(key: key);

  const NotificationListTile.notify({
    Key? key,
    required this.subTitle,
    this.title = 'Valid Keys',
    this.icon,
    this.color = Colors.black,
    this.titleColor = Colors.black,
  }) : super(key: key);

  const NotificationListTile.warning({
    Key? key,
    required this.subTitle,
    this.title = 'Invalid Keys',
    this.icon = const Icon(
      Icons.warning_rounded,
      color: Colors.red,
    ),
    this.color = Colors.red,
    this.titleColor = Colors.red,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final Widget? icon;
  final Color color;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Stack(children: [
        Positioned(
          right: 5,
          child: SizedBox(
            height: 62,
            width: 343,
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              tileColor: color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: SizedBox(
            height: 62,
            width: 343,
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              leading: icon,
              tileColor: Colors.white,
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: titleColor),
              ),
              subtitle: Text(subTitle),
            ),
          ),
        ),
      ]),
    );
  }
}
