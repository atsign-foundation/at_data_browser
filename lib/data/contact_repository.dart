// 🎯 Dart imports:
import 'dart:async';
import 'dart:typed_data';

import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contact/at_contact.dart';
import 'package:at_contacts_flutter/services/contact_service.dart';
import 'package:at_utils/at_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A singleton that makes all the network calls to the @platform.
class ContactsRepository {
  ContactsRepository();

  final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

  AtClient? atClient;
  AtClientService? atClientService;
  var atClientManager = AtClientManager.getInstance();
  static var atContactService = ContactService();

  /// Fetch the current atsign contacts.
  Future<List<AtContact>?> getContactList() async {
    return await atContactService.fetchContacts();
  }

  /// Fetch the current atsign profile image
  Future<Uint8List?> getCurrentAtsignProfileImage() async {
    return atContactService.getContactDetails(atClient!.getCurrentAtSign(), null).then((value) {
      return value['image'];
    });
  }

  /// Fetch details for the current atsign
  AtContact? getCurrentAtsignContactDetails() {
    return atContactService.loggedInUserDetails;
  }

  /// Add contact to contact list.
  Future<bool> addContact(String atSign, String? nickname) async {
    try {
      bool isAdded = await atContactService.addAtSign(atSign: atSign, nickName: nickname);

      return isAdded;
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.message}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }

  /// Delete contact from contact list.
  Future<bool> deleteContact(String atSign) async {
    try {
      bool isDeleted = await atContactService.deleteAtSign(atSign: atSign);

      return isDeleted;
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.message}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }

  /// Add/remove contact as favorite.
  Future<bool> markUnmarkFavoriteContact(AtContact contact) async {
    try {
      bool isMarked = await atContactService.markFavContact(contact);

      return isMarked;
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.message}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }
}

/// A provider that exposes an instance of [ContactsRepository] to the app.
final contactRepositoryProvider = Provider<ContactsRepository>((ref) => ContactsRepository());
