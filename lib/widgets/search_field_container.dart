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

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 152,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kSearchFieldColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
