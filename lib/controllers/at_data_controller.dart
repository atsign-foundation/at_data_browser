import 'dart:developer';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/controllers/filter_form_controller.dart';
import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';

/// A Controller class that controls the UI update when the [AtDataRepository] methods are called.
class AtDataController extends StateNotifier<AsyncValue<List<AtData>>> {
  final Ref ref;

  AtDataController({required this.ref}) : super(const AsyncValue.loading());

  List<String> get apps {
    List<String> nameSpaces = [];
    for (var atData in state.value!) {
      if (atData.atKey.namespace != null) {
        nameSpaces.add(atData.atKey.namespace!);
      }
    }
    return nameSpaces.toSet().toList();
  }

  /// Get list of [AtData] associated with the current astign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
  }

  /// Deletes the [AtKey] associated with the [AtData].
  Future<bool> delete(AtData atData) async {
    state = const AsyncValue.loading();
    final result = await ref.watch(dataRepositoryProvider).deleteData(atData);
    await getData();

    return result;
  }

  /// Deletes all [AtData] associated with the current atsign.
  Future<void> deleteAllData() async {
    state = const AsyncValue.loading();
    await ref.watch(dataRepositoryProvider).deleteAllData();
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
  }
}

/// A provider that exposes the [AtDataController] to the app.
final atDataControllerProvider =
    StateNotifierProvider<AtDataController, AsyncValue<List<AtData>>>((ref) => AtDataController(ref: ref));

class FilterController extends StateNotifier<AsyncValue<List<AtData>>> {
  final Ref ref;

  FilterController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
    getFilteredAtData();
  }

  /// Get list of [AtData] associated with the current astign.

  void getData() async {
    state = ref.watch(atDataControllerProvider);
  }

  /// Get the number of [AtData] associated with the current atsign as a string.
  String itemsStoredCountString() {
    return state.value?.length.toString() ?? 'NA';
  }

  /// Get the number of [AtData] associated with the current atsign.
  int itemsStoredCount() {
    return state.value?.length ?? 0;
  }

  /// Deletes the [AtKey] associated with the [AtData].
  Future<bool> delete(AtData atData) async {
    state = const AsyncValue.loading();
    final result = await ref.watch(dataRepositoryProvider).deleteData(atData);
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
    return result;
  }

  /// Deletes all [AtData] associated with the current atsign.
  Future<void> deleteAllData() async {
    state = const AsyncValue.loading();
    await ref.watch(dataRepositoryProvider).deleteAllData();
    state = await AsyncValue.guard(() async => await ref.watch(dataRepositoryProvider).getData());
  }

  /// Get date from the current [DateTime].
  DateTime _getDate(DateTime dateTime) => DateTime(dateTime.year, dateTime.month, dateTime.day);

  /// Get the [AtData] associated with the current atsign that contains the input.
  void getFilteredAtData() {
    var searchFormModel = ref.watch(searchFormProvider);

    log(searchFormModel.searchRequest.toString());
    String sort = 'ascending';
    state = const AsyncValue.loading();
    getData();
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.where(
          (element) {
            ref.watch(searchFormProvider).isConditionMet = [];
            for (final filterOption in searchFormModel.filter) {
              log("filter Option is : $filterOption");
              // log("filter Option index is : ${filterOption!.index}");
              final int filterOptionIndex = searchFormModel.filter.indexOf(filterOption);
              log(filterOptionIndex.toString());

              var searchContent = searchFormModel.searchRequest[filterOptionIndex].toString();
              switch (filterOption) {
                case Categories.sort:
                  log(searchContent);
                  sort = searchContent;

                  break;
                case Categories.contains:
                  ref.watch(searchFormProvider).isConditionMet.add(element.atKey.toString().contains(searchContent));

                  break;
                case Categories.dateCreated:
                  final createdAt = _getDate(element.atKey.metadata!.createdAt!);

                  log(createdAt.toString());

                  final startDate = _getDate(DateTime.parse(searchContent.split(' - ')[0]));
                  log(startDate.toString());
                  final endDate = _getDate(DateTime.parse(searchContent.split(' - ')[1]));
                  if (createdAt.isAtSameMomentAs(startDate) ||
                      createdAt.isAtSameMomentAs(endDate) ||
                      (createdAt.isAfter(startDate) && createdAt.isBefore(endDate))) {
                    ref.watch(searchFormProvider).isConditionMet.add(true);
                  } else {
                    ref.watch(searchFormProvider).isConditionMet.add(false);
                  }

                  break;
                case Categories.dateModified:
                  log(searchContent);
                  if (element.atKey.metadata?.updatedAt != null) {
                    if (element.atKey.metadata!.updatedAt!.isAfter(DateTime.parse(searchContent.split(' - ')[0])) &&
                        element.atKey.metadata!.updatedAt!.isBefore(DateTime.parse(searchContent.split(' - ')[1]))) {
                      ref.watch(searchFormProvider).isConditionMet.add(true);
                    } else {
                      ref.watch(searchFormProvider).isConditionMet.add(false);
                    }
                  }

                  break;

                case Categories.namespaces:
                  if (element.atKey.namespace != null) {
                    ref.watch(searchFormProvider).isConditionMet.add(element.atKey.namespace!.contains(searchContent));
                  } else {
                    ref.watch(searchFormProvider).isConditionMet.add(false);
                  }
                  break;
                case Categories.atsign:
                  if (element.atKey.key != null) {
                    ref.watch(searchFormProvider).isConditionMet.add(element.atKey.toString().contains(searchContent));
                  } else {
                    ref.watch(searchFormProvider).isConditionMet.add(false);
                  }
                  break;

                case Categories.keyTypes:
                  if (AtKey.getKeyType(element.atKey.toString()).name == searchContent) {
                    ref.watch(searchFormProvider).isConditionMet.add(true);
                  } else {
                    ref.watch(searchFormProvider).isConditionMet.add(false);
                  }
                  break;
                case Categories.sharedWith:
                  if (element.atKey.sharedWith != null) {
                    ref.watch(searchFormProvider).isConditionMet.add(element.atKey.sharedWith!.contains(searchContent));
                  } else {
                    ref.watch(searchFormProvider).isConditionMet.add(false);
                  }
                  break;
                case Categories.sharedBy:
                  if (element.atKey.sharedBy != null) {
                    ref.watch(searchFormProvider).isConditionMet.add(element.atKey.sharedBy!.contains(searchContent));
                  } else {
                    ref.watch(searchFormProvider).isConditionMet.add(false);
                  }
                  break;
                default:
                  ref.watch(searchFormProvider).isConditionMet.add(true);
              }
            }
            // Match found if all conditions are true
            log(searchFormModel.isConditionMet.toString());
            return ref.watch(searchFormProvider).isConditionMet.every((element) => element == true);
          },
        ).toList(),
      );
    }

    // sort the list
    if (sort == 'ascending' && state.value != null) {
      state.value!.sort((a, b) => a.atKey.toString().compareTo(b.atKey.toString()));
    } else if (sort == 'descending' && state.value != null) {
      state.value!.sort((a, b) => b.atKey.toString().compareTo(a.atKey.toString()));
    }
  }
}

/// A provider that filters the [AtDataController] data.
final filterControllerProvider =
    StateNotifierProvider<FilterController, AsyncValue<List<AtData>?>>((ref) => FilterController(ref: ref));
