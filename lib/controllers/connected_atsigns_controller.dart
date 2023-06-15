import 'package:at_contact/at_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';
import '../data/contact_repository.dart';

/// A controller class that controls the UI update when the [AtDataRepository] methods are called.
class ConnectedAtsignsController
    extends StateNotifier<AsyncValue<List<AtContact>?>> {
  final Ref ref;

  ConnectedAtsignsController({required this.ref})
      : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get list of atsigns associated with the current atsign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async =>
        await ref.watch(contactRepositoryProvider).getContactList());
  }

  /// Get the count of atsigns associated with the current atsign as a string.
  String connectedAtsignsCountString() {
    return state.value?.length.toString() ?? 'NA';
  }

  /// Get the count of atsigns associated with the current atsign as an int.
  int connectedAtsignsCount() {
    return state.value?.length ?? 0;
  }

  /// Get the contacts associated with the current atsign that contains the input.
  Future<void> getFilteredConnectedAtsign(String value) async {
    await getData();
    state = AsyncValue.data(
      state.value!.where(
        (element) {
          return element.atSign!.contains(value);
        },
      ).toList(),
    );
  }
}

/// A provider that exposes the [ConnectedAtsignsController] to the app.
final connectedAtsignsControllerProvider = StateNotifierProvider<
        ConnectedAtsignsController, AsyncValue<List<AtContact>?>>(
    (ref) => ConnectedAtsignsController(ref: ref));
