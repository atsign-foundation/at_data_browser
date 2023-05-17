import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/at_data_repository.dart';
import '../domain.dart/at_data.dart';

/// A controller class that controls the UI update when the [AtDataRepository] methods are called.
class HomeScreenController extends StateNotifier<AsyncValue<HomeScreenControllerModel>> {
  final Ref ref;

  HomeScreenController({required this.ref}) : super(const AsyncValue.loading()) {
    getData();
  }

  /// Get [HomeScreenControllerModel] associated the current atsign.
  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final atData = await ref.watch(dataRepositoryProvider).getData();
      final homeScreenControllerModel = HomeScreenControllerModel(
          malformedKeys:
              atData.where((element) => AtKey.getKeyType(element.atKey.toString()) == KeyType.invalidKey).toList(),
          workingKeys:
              atData.where((element) => AtKey.getKeyType(element.atKey.toString()) != KeyType.invalidKey).toList());
      return homeScreenControllerModel;
    });
  }
}

/// A class that holds the data for the [HomeScreenController].
class HomeScreenControllerModel {
  HomeScreenControllerModel({required this.malformedKeys, required this.workingKeys});
  final List<AtData> workingKeys;
  final List<AtData> malformedKeys;
}

/// A provider that exposes the [HomeScreenController] to the app.
final homeScreenControllerProvider = StateNotifierProvider<HomeScreenController, AsyncValue<HomeScreenControllerModel>>(
    (ref) => HomeScreenController(ref: ref));
