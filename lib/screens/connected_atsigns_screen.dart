import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/utils/options.dart';
import 'package:at_data_browser/widgets/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/connected_atsigns_controller.dart';

class ConnectedAtsignsScreen extends ConsumerStatefulWidget {
  static const route = '/connected_atsigns';
  const ConnectedAtsignsScreen({super.key});

  @override
  ConsumerState<ConnectedAtsignsScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends ConsumerState<ConnectedAtsignsScreen> {
  final String _filter = Options.filter[0];

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await ref.watch(connectedAtsignsControllerProvider.notifier).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(connectedAtsignsControllerProvider);
    return Scaffold(
      backgroundColor: kDataStorageFadedColor,
      appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: kDataStorageColor,
          title: const Text('Atsigns'),
          actions: [
            Column(
              children: [
                const Text('Connected Atsigns'),
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(state.value!.length.toString())
              ],
            )
          ]),
      body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              const SearchForm(),
              Expanded(child: Builder(
                builder: (BuildContext context) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      child: ListView.builder(
                          itemCount: state.value!.length,
                          itemBuilder: (context, index) => Column(
                                children: [
                                  ListTile(
                                    title: Text(state.value![index].atSign ?? ''),
                                  ),
                                  const Divider()
                                ],
                              )),
                    );
                  }
                },
              ))
            ],
          )),
    );
  }
}