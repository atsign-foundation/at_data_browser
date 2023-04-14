import 'dart:developer';

import 'package:at_contact/at_contact.dart';
import 'package:at_data_browser/controllers/filter_form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';
import '../data/contact_repository.dart';

/// A Dude class that controls the UI update when the [AtDataRepository] methods are called.
class ConnectedAtsignsController extends StateNotifier<AsyncValue<List<AtContact>?>> {
  final Ref ref;

  ConnectedAtsignsController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get dudes sent to the current astign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await ref.watch(contactRepositoryProvider).getContactList());
  }

  String connectedAtsignsCountString() {
    return state.value?.length.toString() ?? 'NA';
  }

  int connectedAtsignsCount() {
    return state.value?.length ?? 0;
  }

  Future<void> getFilteredConnectedAtsign() async {
    var searchFormModel = ref.watch(searchFormProvider);
    await getData();
    log(searchFormModel.searchRequest.toString());
    state = AsyncValue.data(
      state.value!.where(
        (element) {
          if (element.atSign != null) {
            return element.atSign!.contains(searchFormModel.searchRequest!);
          } else {
            return false;
          }
        },
      ).toList(),
    );
  }

  // Future<void> deleteContact(String atSign) async {
  //   bool result = await ContactsRepository().deleteContact(atSign);
  //   result
  //       ? await getContacts()
  //       : SnackBars.errorSnackBar(
  //           content: 'Contact not deleted',
  //         );
  //   notifyListeners();
  // }

  // /// Get favorite contacts for the current atsign.
  // Future<void> getFavoriteContacts() async {
  //   await getContacts();
  //   _favoriteContacts = _contacts.where((contact) => contact.favourite == true).toList();
  //   notifyListeners();
  // }

  // Future<void> addContacts(String atSign, String? nickname) async {
  //   bool result = await ContactsRepository().addContact(atSign, nickname);
  //   result
  //       ? await getContacts()
  //       : SnackBars.errorSnackBar(
  //           content: 'Error adding atsign, atsign does no exist',
  //         );
  //   notifyListeners();
  // }

  // /// Mark AtContact favourite property as true or false
  // Future<void> markUnmarkFavorites(AtContact contact) async {
  //   bool result = await ContactsRepository().markUnmarkFavoriteContact(contact);
  //   result ? await getFavoriteContacts() : SnackBars.errorSnackBar(content: 'Error adding atsign, atsign may no exist');
  //   notifyListeners();
  // }
}

final connectedAtsignsControllerProvider =
    StateNotifierProvider<ConnectedAtsignsController, AsyncValue<List<AtContact>?>>(
        (ref) => ConnectedAtsignsController(ref: ref));
