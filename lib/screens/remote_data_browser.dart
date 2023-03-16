import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/screens/key_value_detail.dart';
import 'package:flutter/material.dart';

// * Once the onboarding process is completed you will be taken to this screen
class RemoteDataScreen extends StatefulWidget {
  const RemoteDataScreen({Key? key}) : super(key: key);

  @override
  State<RemoteDataScreen> createState() => _RemoteDataScreenState();
}

class _RemoteDataScreenState extends State<RemoteDataScreen> {
  AtClientManager atClientManager = AtClientManager.getInstance();

  Future<List<AtKey>> getKeys() async {
    // List<AtKey> atKeys = [];
    AtClient atClient = atClientManager.atClient;
    // RemoteSecondary? remoteSecondary = atClient.getRemoteSecondary();
    List<AtKey> atKeys = await atClient.getAtKeys();
    // atKeys.add(readKeys[0]);
    return atKeys;
  }

  Future<AtValue> getValue(atKey) async {
    AtClientManager atClientManager = AtClientManager.getInstance();
    AtValue atValue = await atClientManager.atClient.get(atKey);
    return atValue;
  }

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 10),
            // Text(atClientManager.atClient.getCurrentAtSign()!),
            const SizedBox(height: 10),
            FutureBuilder<List<AtKey>>(
                future: getKeys(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // print(snapshot.data!.length);
                    return Flexible(
                      flex: 1,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            AtKey atKey = snapshot.data![index];
                            // print(item!.key);
                            return ListTile(
                              title: Text(
                                "${atKey.sharedWith}${atKey.key}${atKey.sharedBy}",
                                overflow: TextOverflow.visible,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          KeyValueDetailScreen(
                                            atKey: atKey,
                                          )),
                                );
                              },
                            );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const Text("Loading");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
