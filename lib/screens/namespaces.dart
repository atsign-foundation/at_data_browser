import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

// * Once the onboarding process is completed you will be taken to this screen
class NamespacesScreen extends StatefulWidget {
  const NamespacesScreen({Key? key}) : super(key: key);

  @override
  State<NamespacesScreen> createState() => _NamespacesScreenState();
}

class _NamespacesScreenState extends State<NamespacesScreen> {
  AtClientManager atClientManager = AtClientManager.getInstance();

  Future<List<AtKey>> _getKeys() async {
    // List<AtKey> atKeys = [];
    List<AtKey> atKeys = await atClientManager.atClient.getAtKeys();
    // atKeys.add(readKeys[0]);
    return atKeys;
  }

  List<String> _getNamespaces(List<AtKey> atKeys) {
    var uniqueSet = <String>{};
    for (var atKey in atKeys) {
      if (atKey.namespace != null) uniqueSet.add(atKey.namespace!);
    }
    return uniqueSet.toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apps (namespaces)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 10),
            // Text(atClientManager.atClient.getCurrentAtSign()!),
            const SizedBox(height: 10),
            FutureBuilder<List<AtKey>>(
                future: _getKeys(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    // print(snapshot.data!.length);
                    List<String> namespaces = _getNamespaces(snapshot.data!);
                    return Flexible(
                      flex: 1,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: namespaces.length,
                          itemBuilder: (context, index) {
                            String namespace = namespaces[index];
                            // print(item!.key);
                            return ListTile(
                              title: Text(
                                namespace,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.error.toString()),
                    );
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
