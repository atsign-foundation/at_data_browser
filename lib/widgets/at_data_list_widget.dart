import 'package:at_data_browser/widgets/at_data_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain.dart/at_data.dart';
import '../utils/constants.dart';

class AtDataListWidget extends StatefulWidget {
  const AtDataListWidget({
    super.key,
    required this.state,
  });

  final AsyncValue<List<AtData>> state;

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
          return SingleChildScrollView(
            child: Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
              child: ExpansionPanelList(
                dividerColor: kDataStorageFadedColor,
                elevation: 0,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    isExpandPanel[index] = !isExpanded;
                  });
                },
                children: widget.state.value!.map((e) {
                  isExpandPanel.add(false);
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    backgroundColor: Colors.transparent,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 29, right: 54, top: 14, bottom: 9),
                        child: Text(
                          e.atKey.toString(),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      );
                    },
                    body: AtDataExpansionPanelList(
                        atData: widget
                            .state.value![widget.state.value!.indexOf(e)]),
                    isExpanded: isExpandPanel[widget.state.value!.indexOf(e)],
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
