import 'dart:developer';

import 'package:at_data_browser/controllers/at_data_controller.dart';
import 'package:at_data_browser/data/navigation_service.dart';
import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';

/// A controller class that controls the UI update when the [AtDataRepository] methods are called.
class AppController extends StateNotifier<AsyncValue<List<String>>> {
  final Ref ref;

  AppController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get unique list of app/namespaces associated with the current atsign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final atDataList = ref.watch(atDataControllerProvider).asData!.value;
      List<String> nameSpaces = [];
      for (var atData in atDataList) {
        if (atData.atKey.namespace != null) {
          nameSpaces.add(atData.atKey.namespace!);
        }
      }
      return nameSpaces.toSet().toList();
    });
  }

  /// Get the count of apps/namespaces associated with the current atsign.
  int itemsStoredCount(List<AtData> atDataList) {
    return state.value?.length ?? 0;
  }

  /// Get the number of apps/namespaces associated with the current atsign as a string.
  String getNameSpacesCountString(List<AtData> atDataList) {
    return state.value?.length.toString() ?? AppLocalizations.of(NavigationService.navKey.currentContext!)!.na;
  }

  /// Get the apps/namespaces associated with the current atsign that contains the input.
  Future<void> getFilteredConnectedApps(String value) async {
    log('filter called');
    await getData();
    state = AsyncValue.data(
      state.value!.where(
        (element) {
          return element.contains(value);
        },
      ).toList(),
    );
  }
}

/// A provider that exposes the [AppController] to the app.
final appsController = StateNotifierProvider<AppController, AsyncValue<List<String>>>((ref) => AppController(ref: ref));
