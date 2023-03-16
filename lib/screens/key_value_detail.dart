import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

// * Once the onboarding process is completed you will be taken to this screen
class KeyValueDetailScreen extends StatefulWidget {
  final AtKey? atKey;
  const KeyValueDetailScreen({Key? key, this.atKey}) : super(key: key);

  @override
  State<KeyValueDetailScreen> createState() => _KeyValueDetailScreenState();
}

class _KeyValueDetailScreenState extends State<KeyValueDetailScreen> {
  AtClientManager atClientManager = AtClientManager.getInstance();

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
        title: const Text('Local Data'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(atClientManager.atClient.getCurrentAtSign()!),
          const SizedBox(height: 25),
          FutureBuilder<AtValue>(
              future: getValue(widget.atKey),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  // print(snapshot.data!.length);
                  return Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text("AtKey",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text("${widget.atKey!}"),
                            // const Text("AtKey Metadata",
                            //     style: TextStyle(fontWeight: FontWeight.bold)),
                            // const SizedBox(height: 5),
                            // Text("${widget.atKey!.metadata}"),
                            const SizedBox(height: 25),
                            const Text(
                              "AtValue",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text("${snapshot.data!.value}"),
                            const SizedBox(height: 25),
                            const Text(
                              "MetaData",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text("${snapshot.data!.metadata}"),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Loading"),
                  );
                }
              }),
        ],
      ),
    );
  }
}
