import 'package:at_data_browser/data/authentication_repository.dart';
import 'package:at_data_browser/widgets/nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var atsign = ref.watch(authenticationRepositoryProvider).getCurrentAtSign();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            Expanded(
                child: Column(children: [
              ListTile(
                title: const Text('DataBrowser'),
                subtitle: Text(atsign ?? ""),
              ),
              Image.asset(
                'assets/images/data_browser.png',
                color: Colors.grey.shade200,
              )
            ])),
            const NavWidget(),
          ],
        ),
      ),
    );
  }
}
