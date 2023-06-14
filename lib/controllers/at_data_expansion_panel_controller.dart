import 'package:at_data_browser/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A class that holds the [Color]s of the [AtDataExpansionPanel] widget.
class AtDataExpansionPanelModel {
  AtDataExpansionPanelModel(
      {required this.primaryColor, required this.fadedColor});
  Color primaryColor;
  Color fadedColor;
}

/// A Provider that provides the [AtDataExpansionPanelModel] to the [AtDataExpansionPanel] widget.
final atDataExpansionPanelModelProvider =
    Provider<AtDataExpansionPanelModel>((ref) {
  return AtDataExpansionPanelModel(
    primaryColor: kDataStorageColor,
    fadedColor: kDataStorageFadedColor,
  );
});
