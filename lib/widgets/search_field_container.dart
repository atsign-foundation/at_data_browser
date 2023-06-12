import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SearchFieldContainer extends StatelessWidget {
  const SearchFieldContainer({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 152,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kSearchFieldColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
