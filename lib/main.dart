import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';
import 'package:at_data_browser/screens/apps_screen.dart';
import 'package:at_data_browser/screens/connected_atsigns_screen.dart';
import 'package:at_data_browser/screens/data_storage_screen.dart';
import 'package:at_data_browser/utils/theme.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' show getApplicationSupportDirectory;

import 'data/navigation_service.dart';
import 'screens/home_screen.dart';

final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

Future<void> main() async {
  // * AtEnv is an abstraction of the flutter_dotenv package used to
  // * load the environment variables set by at_app
  try {
    await AtEnv.load();
  } catch (e) {
    _logger.finer('Environment failed to load from .env: ', e);
  }
  runApp(const ProviderScope(child: MyApp()));
}

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await getApplicationSupportDirectory();

  return AtClientPreference()
    ..rootDomain = AtEnv.rootDomain
    ..namespace = AtEnv.appNamespace
    ..hiveStoragePath = dir.path
    ..commitLogPath = dir.path
    ..isLocalStoreRequired = true;
  // TODO
  // * By default, this configuration is suitable for most applications
  // * In advanced cases you may need to modify [AtClientPreference]
  // * Read more here: https://pub.dev/documentation/at_client/latest/at_client/AtClientPreference-class.html
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // * load the AtClientPreference in the background
  Future<AtClientPreference> futurePreference = loadAtClientPreference();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navKey,
      theme: AppTheme.light(),
      // * The onboarding screen (first screen)
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MyApp'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                AtOnboardingResult onboardingResult = await AtOnboarding.onboard(
                  context: context,
                  config: AtOnboardingConfig(
                    atClientPreference: await futurePreference,
                    rootEnvironment: AtEnv.rootEnvironment,
                    domain: AtEnv.rootDomain,
                    appAPIKey: AtEnv.appApiKey,
                  ),
                );
                switch (onboardingResult.status) {
                  case AtOnboardingResultStatus.success:
                    _goLocalData(context);
                    initializeContactsService(rootDomain: AtEnv.rootDomain);
                    break;
                  case AtOnboardingResultStatus.error:
                    _handleError(context);
                    break;
                  case AtOnboardingResultStatus.cancel:
                    break;
                }
              },
              child: const Text('Onboard an @sign'),
            ),
          ),
        ),
      ),
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        DataStorageScreen.route: (_) => const DataStorageScreen(),
        ConnectedAtsignsScreen.route: (_) => const ConnectedAtsignsScreen(),
        AppsScreen.route: (_) => const AppsScreen(),
      },
    );
  }

  void _goLocalData(context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _handleError(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('An error has occurred'),
      ),
    );
  }
}
