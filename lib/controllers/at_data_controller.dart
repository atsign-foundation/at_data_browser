import 'dart:developer';

import 'package:at_data_browser/controllers/filter_form_controller.dart';
import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:riverpod/riverpod.dart';

import '../data/at_data_repository.dart';

/// A Dude class that controls the UI update when the [AtDataRepository] methods are called.
class AtDataController extends StateNotifier<AsyncValue<List<AtData>>> {
  final Ref ref;

  AtDataController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get dudes sent to the current astign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
  }

  String itemsStoredCountString() {
    return state.value?.length.toString() ?? 'NA';
  }

  int itemsStoredCount() {
    return state.value?.length ?? 0;
  }

  /// Deletes dudes sent to the current atsign.
  ///
  Future<void> deleteData(AtData atData) async {
    state = const AsyncValue.loading();
    await ref.watch(dataRepositoryProvider).deleteData(atData);
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
  }

  Future<void> deleteAllData() async {
    state = const AsyncValue.loading();
    await ref.watch(dataRepositoryProvider).deleteAllData();
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
  }

  Future<void> getFilteredAtData() async {
    var searchFormModel = ref.watch(searchFormProvider);
    await getData();
    log(searchFormModel.searchRequest.toString());
    state = AsyncValue.data(
      state.value!.where(
        (element) {
          switch (searchFormModel.filter) {
            case 'Contains':
              return element.atKey.key!.contains(searchFormModel.searchRequest!);

            case 'Starts With':
              return element.atKey.key!.startsWith(searchFormModel.searchRequest!);

            case 'Ends With':
              return element.atKey.key!.endsWith(searchFormModel.searchRequest!);
            case 'Namespace':
              if (element.atKey.namespace != null) {
                return element.atKey.namespace!.contains(searchFormModel.searchRequest!);
              } else {
                return false;
              }
            case 'Shared With':
              return element.atKey.sharedWith!.contains(searchFormModel.searchRequest!);
            case 'Shared By':
              return element.atKey.sharedBy!.contains(searchFormModel.searchRequest!);
            default:
              return true;
          }
        },
      ).toList(),
    );
  }
}

final atDataControllerProvider =
    StateNotifierProvider<AtDataController, AsyncValue<List<AtData>>>((ref) => AtDataController(ref: ref));
