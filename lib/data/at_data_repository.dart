// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';

import 'package:at_app_flutter/at_app_flutter.dart';
// ignore: implementation_imports
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contacts_flutter/services/contact_service.dart';
import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:at_utils/at_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A singleton that makes network calls to the @platform to get data.
class AtDataRepository {
  AtDataRepository();
  final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

  AtClientService? atClientService;
  var atClientManager = AtClientManager.getInstance();

  static var contactService = ContactService();

  /// Receives all [AtData] sent to the current atsign.
  Future<List<AtData>> getData() async {
    List<AtKey> receivedKeysList = [];
    var key = await atClientManager.atClient.getAtKeys();

    receivedKeysList.addAll(key);

    List<AtData> data = [];
    for (AtKey key in receivedKeysList) {
      try {
        AtValue atValue = await atClientManager.atClient.get(key);

        data.add(AtData(atKey: key, atValue: atValue));
      } on Exception catch (e) {
        ScaffoldMessenger(child: SnackBar(content: Text(e.toString())));
      }
    }
    return data;
  }

  /// Delete [AtKey] associated with the [AtData]
  Future<bool> deleteData(AtData atData) async {
    try {
      bool isDeleted = await atClientManager.atClient.delete(atData.atKey);
      log('isDeleted: $isDeleted');
      return isDeleted;
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.message}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }

  /// Delete all [AtKey]s associated with the current atsign.
  Future<bool> deleteAllData() async {
    // will delate all instances that match the key

    var success = true;
    var atKeys = await AtClientManager.getInstance().atClient.getAtKeys(regex: 'cached:@');
    for (var atKey in atKeys) {
      success = success && await AtClientManager.getInstance().atClient.delete(atKey);
    }
    _logger.info('delete returning success = $success');
    return success;
  }
}

/// A provider that exposes the [AtDataRepository] to the app.
final dataRepositoryProvider = Provider<AtDataRepository>((ref) => AtDataRepository());
