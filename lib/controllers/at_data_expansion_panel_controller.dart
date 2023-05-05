import 'package:at_data_browser/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AtDataExpansionPanelModel {
  AtDataExpansionPanelModel({required this.primaryColor, required this.fadedColor});
  Color primaryColor;
  Color fadedColor;
}

final atDataExpansionPanelModelProvider = Provider<AtDataExpansionPanelModel>((ref) {
  return AtDataExpansionPanelModel(
    primaryColor: kDataStorageColor,
    fadedColor: kDataStorageFadedColor,
  );
});
