import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/apps_controller.dart';
import '../controllers/at_data_controller.dart';

class AppsSearchWidget extends ConsumerStatefulWidget {
  const AppsSearchWidget({super.key});

  @override
  ConsumerState<AppsSearchWidget> createState() => _SearchCategroyWidgetState();
}

class _SearchCategroyWidgetState extends ConsumerState<AppsSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
                  },
                ),
              ),
              onChanged: (value) async {
                log('change called');
                log('message: $value');

                await ref.read(appsController.notifier).getFilteredConnectedApps(value);
              },
            )),
      ),
    );
  }
}
