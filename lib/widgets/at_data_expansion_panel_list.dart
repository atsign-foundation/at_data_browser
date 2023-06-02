import 'dart:convert';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/controllers/at_data_controller.dart';
import 'package:at_data_browser/controllers/at_data_expansion_panel_controller.dart';
import 'package:at_data_browser/utils/sizes.dart';
import 'package:at_data_browser/widgets/at_data_expansion_panel_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain.dart/at_data.dart';

class AtDataExpansionPanelList extends ConsumerStatefulWidget {
  const AtDataExpansionPanelList({required this.atData, super.key});
  final AtData atData;

  @override
  ConsumerState<AtDataExpansionPanelList> createState() =>
      _AtDataExpansionPanelListState();
}

class _AtDataExpansionPanelListState
    extends ConsumerState<AtDataExpansionPanelList> {
  List<bool> isExpandPanel = [false, false, false];

  bool isDeletable(String key) {
    final KeyType keyType = AtKey.getKeyType(key);
    switch (keyType) {
      case KeyType.reservedKey:
        return false;

      default:
        return true;
    }
  }

  List<AtDataProperty> _getAtValue() {
    List<AtDataProperty> data = [];
    try {
      jsonDecode(widget.atData.atValue.value).forEach((key, value) {
        data.add(AtDataProperty(title: key, value: value.toString()));
      });
      return data;
    } catch (e) {
      return [
        AtDataProperty(
            title: 'Value', value: widget.atData.atValue.value.toString())
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionPanelList(
            dividerColor: Colors.transparent,
            elevation: 0,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isExpandPanel[index] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                isExpanded: isExpandPanel[0],
                canTapOnHeader: true,
                backgroundColor: Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ref
                          .watch(atDataExpansionPanelModelProvider)
                          .primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'atKey',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  );
                },
                body: AtDataExpansionPanelBody(
                  properties: [
                    AtDataProperty(
                      title: 'isRef',
                      value: widget.atData.atKey.isRef.toString(),
                    ),
                    AtDataProperty(
                      title: 'key',
                      value: widget.atData.atKey.key.toString(),
                    ),
                    AtDataProperty(
                      title: 'hashCode',
                      value: widget.atData.atKey.hashCode.toString(),
                    ),
                    AtDataProperty(
                      title: 'isLocal',
                      value: widget.atData.atKey.isLocal.toString(),
                    ),
                    AtDataProperty(
                      title: 'namespace',
                      value: widget.atData.atKey.namespace.toString(),
                    ),
                    AtDataProperty(
                      title: 'runtimeType',
                      value: widget.atData.atKey.runtimeType.toString(),
                    ),
                    AtDataProperty(
                      title: 'shareBy',
                      value: widget.atData.atKey.sharedBy.toString(),
                    ),
                    AtDataProperty(
                      title: 'shareWith',
                      value: widget.atData.atKey.sharedWith.toString(),
                    ),
                  ],
                ),
              ),
              ExpansionPanel(
                isExpanded: isExpandPanel[1],
                canTapOnHeader: true,
                backgroundColor: Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ref
                          .watch(atDataExpansionPanelModelProvider)
                          .primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'metadata',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  );
                },
                body: AtDataExpansionPanelBody(
                  properties: [
                    AtDataProperty(
                      title: 'ttl',
                      value: widget.atData.atKey.metadata!.ttl.toString(),
                    ),
                    AtDataProperty(
                      title: 'ttb',
                      value: widget.atData.atKey.metadata!.ttb.toString(),
                    ),
                    AtDataProperty(
                      title: 'ttr',
                      value: widget.atData.atKey.metadata!.ttr.toString(),
                    ),
                    AtDataProperty(
                      title: 'ccd',
                      value: widget.atData.atKey.metadata!.ccd.toString(),
                    ),
                    AtDataProperty(
                      title: 'isPublic',
                      value: widget.atData.atKey.metadata!.isPublic.toString(),
                    ),
                    AtDataProperty(
                      title: 'isHidden',
                      value: widget.atData.atKey.metadata!.isHidden.toString(),
                    ),
                    AtDataProperty(
                      title: 'availableAt',
                      value:
                          widget.atData.atKey.metadata!.availableAt.toString(),
                    ),
                    AtDataProperty(
                      title: 'expiresAt',
                      value: widget.atData.atKey.metadata!.expiresAt.toString(),
                    ),
                    AtDataProperty(
                      title: 'refreshAt',
                      value: widget.atData.atKey.metadata!.refreshAt.toString(),
                    ),
                    AtDataProperty(
                      title: 'createdAt',
                      value: widget.atData.atKey.metadata!.createdAt.toString(),
                    ),
                    AtDataProperty(
                      title: 'updatedAt',
                      value: widget.atData.atKey.metadata!.updatedAt.toString(),
                    ),
                    AtDataProperty(
                      title: 'isBinary',
                      value: widget.atData.atKey.metadata!.isBinary.toString(),
                    ),
                    AtDataProperty(
                      title: 'isEncrypted',
                      value:
                          widget.atData.atKey.metadata!.isEncrypted.toString(),
                    ),
                    AtDataProperty(
                      title: 'isCached',
                      value: widget.atData.atKey.metadata!.isCached.toString(),
                    ),
                    AtDataProperty(
                      title: 'dataSignature',
                      value: widget.atData.atKey.metadata!.dataSignature
                          .toString(),
                    ),
                    AtDataProperty(
                      title: 'sharedKeyStatus',
                      value: widget.atData.atKey.metadata!.sharedKeyStatus
                          .toString(),
                    ),
                    AtDataProperty(
                      title: 'sharedKeyEnc',
                      value:
                          widget.atData.atKey.metadata!.sharedKeyEnc.toString(),
                    ),
                    AtDataProperty(
                      title: 'pubKeyCS',
                      value: widget.atData.atKey.metadata!.pubKeyCS.toString(),
                    ),
                    AtDataProperty(
                      title: 'encoding',
                      value: widget.atData.atKey.metadata!.encoding.toString(),
                    ),
                    AtDataProperty(
                      title: 'encKeyName',
                      value:
                          widget.atData.atKey.metadata!.encKeyName.toString(),
                    ),
                    AtDataProperty(
                      title: 'encAlgo',
                      value: widget.atData.atKey.metadata!.encAlgo.toString(),
                    ),
                    AtDataProperty(
                      title: 'ivNonce',
                      value: widget.atData.atKey.metadata!.ivNonce.toString(),
                    ),
                    AtDataProperty(
                      title: 'skeEncKeyName',
                      value: widget.atData.atKey.metadata!.skeEncKeyName
                          .toString(),
                    ),
                    AtDataProperty(
                      title: 'skeEncAlgo',
                      value:
                          widget.atData.atKey.metadata!.skeEncAlgo.toString(),
                    ),
                  ],
                ),
              ),
              ExpansionPanel(
                isExpanded: isExpandPanel[2],
                canTapOnHeader: true,
                backgroundColor: Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ref
                          .watch(atDataExpansionPanelModelProvider)
                          .primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'atValue',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  );
                },
                body: AtDataExpansionPanelBody(
                  properties: _getAtValue(),
                ),
              ),
            ],
          ),
          isDeletable(widget.atData.atKey.toString())
              ? ElevatedButton(
                  onPressed: () async {
                    await ref
                        .watch(atDataControllerProvider.notifier)
                        .delete(widget.atData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5),
                    // ),
                  ),
                  child: const Text('Delete'),
                )
              : gap0,
        ],
      ),
    );
  }
}
