import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';

/// A Dude class that controls the UI update when the [AtDataRepository] methods are called.
class HomeScreenController extends StateNotifier<AsyncValue<HomeScreenControllerModel>> {
  final Ref ref;

  HomeScreenController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get dudes sent to the current astign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final atData = await ref.watch(dataRepositoryProvider).getData();
      final homeScreenControllerModel = HomeScreenControllerModel(
          malformedKeys:
              atData.where((element) => AtKey.getKeyType(element.atKey.key!) == KeyType.invalidKey).toList().length,
          workingKeys:
              atData.where((element) => AtKey.getKeyType(element.atKey.key!) != KeyType.invalidKey).toList().length);
      return homeScreenControllerModel;
    });
  }
}

class HomeScreenControllerModel {
  HomeScreenControllerModel({required this.malformedKeys, required this.workingKeys});
  final int workingKeys;
  final int malformedKeys;
}

final homeScreenControllerProvider = StateNotifierProvider<HomeScreenController, AsyncValue<HomeScreenControllerModel>>(
    (ref) => HomeScreenController(ref: ref));
