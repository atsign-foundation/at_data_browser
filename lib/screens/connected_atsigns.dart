import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

// * Once the onboarding process is completed you will be taken to this screen
class ConnectedAtSignsScreen extends StatefulWidget {
  const ConnectedAtSignsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectedAtSignsScreen> createState() => _ConnectedAtSignsScreenState();
}

class _ConnectedAtSignsScreenState extends State<ConnectedAtSignsScreen> {
  AtClientManager atClientManager = AtClientManager.getInstance();

  Future<List<AtKey>> _getKeys() async {
    // List<AtKey> atKeys = [];
    List<AtKey> atKeys = await atClientManager.atClient.getAtKeys();
    // atKeys.add(readKeys[0]);
    return atKeys;
  }

  List<String> _getConnectedAtSigns(List<AtKey> atKeys) {
    var uniqueSet = <String>{};
    for (var atKey in atKeys) {
      if (atKey.sharedBy != null) uniqueSet.add(atKey.sharedBy!);
      if (atKey.sharedWith != null) uniqueSet.add(atKey.sharedWith!);
    }
    return uniqueSet.toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected AtSigns'),
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
                    List<String> atSigns = _getConnectedAtSigns(snapshot.data!);
                    return Flexible(
                      flex: 1,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: atSigns.length,
                          itemBuilder: (context, index) {
                            String atSign = atSigns[index];
                            return ListTile(
                              title: Text(
                                atSign,
                                overflow: TextOverflow.ellipsis,
                              ),
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
