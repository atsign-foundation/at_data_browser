import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';
import 'filter_form_controller.dart';

/// A Dude class that controls the UI update when the [AtDataRepository] methods are called.
class AppController extends StateNotifier<AsyncValue<List<String>>> {
  final Ref ref;

  AppController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get dudes sent to the current astign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final atDataList = await ref.watch(dataRepositoryProvider).getData();
      List<String> nameSpaces = [];
      for (var atData in atDataList) {
        if (atData.atKey.namespace != null) {
          nameSpaces.add(atData.atKey.namespace!);
        }
      }
      return nameSpaces.toSet().toList();
    });
  }

  int itemsStoredCount(List<AtData> atDataList) {
    return state.value?.length ?? 0;
  }

  String getNameSpacesCountString(List<AtData> atDataList) {
    return state.value?.length.toString() ?? 'NA';
  }

  Future<void> getFilteredConnectedApps() async {
    var searchFormModel = ref.watch(searchFormProvider);
    await getData();

    state = AsyncValue.data(
      state.value!.where(
        (element) {
          return element.contains(searchFormModel.searchRequest!);
        },
      ).toList(),
    );
  }
}

final appsController = StateNotifierProvider<AppController, AsyncValue<List<String>>>((ref) => AppController(ref: ref));
