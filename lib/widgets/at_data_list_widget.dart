import 'package:at_data_browser/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain.dart/at_data.dart';

class AtDataListWidget extends StatelessWidget {
  const AtDataListWidget({
    super.key,
    required this.state,
  });

  final AsyncValue<List<AtData>> state;

  @override
  Widget build(BuildContext context) {
    return Builder(
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
                          title: Text(
                            state.value![index].atKey.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const Divider(
                          color: kBrowserFadedColor,
                        )
                      ],
                    )),
          );
        }
      },
    );
  }
}
