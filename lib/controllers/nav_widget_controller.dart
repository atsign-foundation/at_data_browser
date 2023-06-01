import 'package:at_data_browser/controllers/at_data_controller.dart';
import 'package:at_data_browser/data/contact_repository.dart';
import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';

/// A controller class that controls the UI update when the [AtDataRepository] methods are called.
class NavWidgetController extends StateNotifier<AsyncValue<NavWidgetModel>> {
  final Ref ref;

  NavWidgetController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get [NavWidgetModel] associated the current atsign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final atDataList = ref.watch(atDataControllerProvider).value!;

      final atContact = await ref.watch(contactRepositoryProvider).getContactList();

      return NavWidgetModel(
          dataStorageCount: itemsStoredCount(atDataList),
          atContactsCount: atContact?.length.toString() ?? "NA",
          namespacesCount: getNameSpacesCount(atDataList));
    });
  }

  /// Get the number of [AtData] associated wit the current atsign.
  String itemsStoredCount(List<AtData> atDataList) {
    return atDataList.length.toString();
  }

  /// Get the number of apps/namespaces associated with the current atsign as a string.
  String getNameSpacesCount(List<AtData> atDataList) {
    List<String?> nameSpaces = [];
    for (var atData in atDataList) {
      nameSpaces.add(atData.atKey.namespace);
    }
    return nameSpaces.toSet().toList().length.toString();
  }
}

/// A class that holds the data for the [NavWidgetController].
class NavWidgetModel {
  NavWidgetModel({required this.dataStorageCount, required this.atContactsCount, required this.namespacesCount});
  final String dataStorageCount;
  final String atContactsCount;
  final String namespacesCount;
}

/// A provider that exposes the [NavWidgetController] to the app.
final navWidgetController =
    StateNotifierProvider<NavWidgetController, AsyncValue<NavWidgetModel>>((ref) => NavWidgetController(ref: ref));
