import 'dart:developer';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_data_browser/controllers/filter_form_controller.dart';
import 'package:at_data_browser/domain.dart/at_data.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  DateTime _getDate(DateTime dateTime) => DateTime(dateTime.year, dateTime.month, dateTime.day);

  Future<void> getFilteredAtData() async {
    var searchFormModel = ref.watch(searchFormProvider);
    await getData();
    log(searchFormModel.searchRequest.toString());
    String sort = 'ascending';
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

              case Categories.apps:
                if (element.atKey.namespace != null) {
                  ref.watch(searchFormProvider).isConditionMet.add(element.atKey.namespace!.contains(searchContent));
                } else {
                  ref.watch(searchFormProvider).isConditionMet.add(false);
                }
                break;
              case Categories.atsign:
                if (element.atKey.key != null) {
                  ref.watch(searchFormProvider).isConditionMet.add(element.atKey.key!.contains(searchContent));
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

    // sort the list
    if (sort == 'ascending') {
      state.value!.sort((a, b) => a.atKey.toString().compareTo(b.atKey.toString()));
    } else if (sort == 'descending') {
      state.value!.sort((a, b) => b.atKey.toString().compareTo(a.atKey.toString()));
    }
  }
}

final atDataControllerProvider =
    StateNotifierProvider<AtDataController, AsyncValue<List<AtData>>>((ref) => AtDataController(ref: ref));
