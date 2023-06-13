import 'package:at_data_browser/utils/constants.dart';
import 'package:at_data_browser/widgets/at_data_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain.dart/at_data.dart';

class AtDataListWidget extends StatefulWidget {
  const AtDataListWidget({
    super.key,
    required this.state,
  });

  final AsyncValue<List<AtData>?> state;

  @override
  State<AtDataListWidget> createState() => _AtDataListWidgetState();
}

class _AtDataListWidgetState extends State<AtDataListWidget> {
  List<bool> isExpandPanel = [];
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        if (widget.state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
            child: ListView.builder(
                itemBuilder: (buildContext, builderIndex) {
                  isExpandPanel.add(false);
                  return Column(
                    children: [
                      ExpansionPanelList.radio(
                        elevation: 0,
                        // expansionCallback: (int index, bool isExpanded) {
                        //   log(isExpanded.toString());
                        //   isExpandPanel[index] = !isExpanded;
                        //   setState(() {
                        //     log(isExpandPanel.toString());
                        //   });
                        // },
                        children: [
                          ExpansionPanelRadio(
                            value: builderIndex,
                            canTapOnHeader: true,
                            backgroundColor: Colors.transparent,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              // isExpandPanel[0] = isExpanded;

                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      widget.state.value![builderIndex].atKey
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                ),
                              );
                            },
                            body: AtDataExpansionPanelList(
                                atData: widget.state.value![builderIndex]),
                            // isExpanded: isExpandPanel[0],
                          ),
                        ],
                      ),
                      const Divider(color: kDataStorageFadedColor, thickness: 1)
                    ],
                  );
                },
                itemCount: widget.state.value!.length),
          );
        }
      },
    );
  }
}
