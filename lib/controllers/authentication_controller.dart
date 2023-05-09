import 'package:at_contact/at_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/authentication_repository.dart';
import '../data/contact_repository.dart';

/// A Dude class that controls the UI update when the [ContactsRepository] methods are called.
class AuthenticationController extends StateNotifier<AsyncValue<List<String>?>> {
  final Ref ref;
  AuthenticationController({required this.ref}) : super(const AsyncValue.loading());

  /// Get contacts for the current atsign.
  Future<void> getAtSignList() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async => await ref.watch(authenticationRepositoryProvider).getAtsignList());
  }

  Future<AtContact> getAtContact(String atSign) async {
    return await ref.watch(authenticationRepositoryProvider).getAtContact(atSign);
  }

  Future<String?> getCurrentAtSign() async {
    return ref.watch(authenticationRepositoryProvider).getCurrentAtSign();
  }

  Future<AtContact> getCurrentAtContact() async {
    return await ref.watch(authenticationRepositoryProvider).getCurrentAtContact();
  }
}

final authenticationController = StateNotifierProvider<AuthenticationController, AsyncValue<List<String>?>>(
    (ref) => AuthenticationController(ref: ref));
