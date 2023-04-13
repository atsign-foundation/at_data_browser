import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/screens/connected_atsigns.dart';
import 'package:at_data_browser/screens/local_data_browser.dart';
import 'package:at_data_browser/screens/namespaces.dart';
import 'package:flutter/material.dart';

// * Once the onboarding process is completed you will be taken to this screen
class AltHomeScreen extends StatefulWidget {
  const AltHomeScreen({Key? key}) : super(key: key);

  @override
  State<AltHomeScreen> createState() => _AltHomeScreenState();
}

class _AltHomeScreenState extends State<AltHomeScreen> {
  AtClientManager atClientManager = AtClientManager.getInstance();

  Future<List<AtKey>> _getKeys() async {
    List<AtKey> atKeys = await atClientManager.atClient.getAtKeys();
    return atKeys;
  }

  int _connectedAtSignCount(List<AtKey> atKeys) {
    var uniqueSet = <String>{};
    for (var atKey in atKeys) {
      if (atKey.sharedBy != null) uniqueSet.add(atKey.sharedBy!);
      if (atKey.sharedWith != null) uniqueSet.add(atKey.sharedWith!);
    }
    return uniqueSet.length;
  }

  int _namespaceCount(List<AtKey> atKeys) {
    var uniqueSet = <String>{};
    for (var atKey in atKeys) {
      if (atKey.namespace != null) uniqueSet.add(atKey.namespace!);
    }
    return uniqueSet.length;
  }

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(atClientManager.atClient.getCurrentAtSign()!),
            const SizedBox(height: 25),
            FutureBuilder<List<AtKey>>(
                future: _getKeys(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    int atSigns = _connectedAtSignCount(snapshot.data!);
                    int namespaces = _namespaceCount(snapshot.data!);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text("Data Storage", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            GestureDetector(
                              child: Text("items stored: ${snapshot.data!.length}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LocalDataScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Apps (Namespaces)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              child: Text("Namespaces: $namespaces"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NamespacesScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "AtSigns",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              child: Text("Connected atSigns: $atSigns"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ConnectedAtSignsScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
