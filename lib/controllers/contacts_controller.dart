import 'package:at_contact/at_contact.dart';
import 'package:flutter/material.dart';

import '../data/contact_repository.dart';
import '../widgets/snackbars.dart';

/// A Dude class that controls the UI update when the [ContactsRepository] methods are called.
class ContactsController extends ChangeNotifier {
  List<AtContact> _contacts = [];

  List<AtContact> get contacts {
    return [..._contacts];
  }

  List<AtContact> _favoriteContacts = [];
  List<AtContact> get favoriteContacts {
    return _favoriteContacts;
  }

  /// Get contacts for the current atsign.
  Future<void> getContacts() async {
    _contacts = await ContactsRepository().getContactList() ?? [];

    notifyListeners();
  }

  Future<void> deleteContact(String atSign) async {
    bool result = await ContactsRepository().deleteContact(atSign);
    result
        ? await getContacts()
        : SnackBars.errorSnackBar(
            content: 'Contact not deleted',
          );
    notifyListeners();
  }

  /// Get favorite contacts for the current atsign.
  Future<void> getFavoriteContacts() async {
    await getContacts();
    _favoriteContacts = _contacts.where((contact) => contact.favourite == true).toList();
    notifyListeners();
  }

  Future<void> addContacts(String atSign, String? nickname) async {
    bool result = await ContactsRepository().addContact(atSign, nickname);
    result
        ? await getContacts()
        : SnackBars.errorSnackBar(
            content: 'Error adding atsign, atsign does no exist',
          );
    notifyListeners();
  }

  /// Mark AtContact favourite property as true or false
  Future<void> markUnmarkFavorites(AtContact contact) async {
    bool result = await ContactsRepository().markUnmarkFavoriteContact(contact);
    result ? await getFavoriteContacts() : SnackBars.errorSnackBar(content: 'Error adding atsign, atsign may no exist');
    notifyListeners();
  }
}
