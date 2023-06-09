import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';
import 'package:at_data_browser/screens/apps_screen.dart';
import 'package:at_data_browser/screens/browse_screen.dart';
import 'package:at_data_browser/screens/connected_atsigns_screen.dart';
import 'package:at_data_browser/screens/data_storage_screen.dart';
import 'package:at_data_browser/screens/home_screen.dart';
import 'package:at_data_browser/screens/settings_screen.dart';
import 'package:at_data_browser/utils/sizes.dart';
import 'package:at_data_browser/utils/theme.dart';
import 'package:at_data_browser/widgets/reset_app_button.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' show getApplicationSupportDirectory;

import './data/navigation_service.dart';

final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

Future<void> main() async {
  // * AtEnv is an abstraction of the flutter_dotenv package used to
  // * load the environment variables set by at_app
  try {
    await AtEnv.load();
  } catch (e) {
    _logger.finer('Environment failed to load from .env: ', e);
  }
  AtSignLogger.root_level = 'finer';
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
    final textStyle = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      // * The onboarding screen (first screen)
      home: Builder(builder: (context) {
        final strings = AppLocalizations.of(context)!;
        return Scaffold(
          extendBody: true,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/onboarding.gif',
                        ))),
              ),
              gapH32,
              Text(
                strings.onboardingTitle,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),
              ),
              gapH8,
              SizedBox(
                width: 300,
                height: 75,
                child: Text(
                  strings.onboardingDesc,
                  style: textStyle.bodyLarge!.copyWith(fontSize: Sizes.p18),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
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
                      if (context.mounted) _goLocalData(context);
                      initializeContactsService(rootDomain: AtEnv.rootDomain);
                      break;
                    case AtOnboardingResultStatus.error:
                      if (context.mounted) _handleError(context);
                      break;
                    case AtOnboardingResultStatus.cancel:
                      break;
                  }
                },
                child: Text(
                  strings.onboardAnAtsign,
                  style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ),
              gapH16,
              const ResetAppButton(
                isOnboardingScreen: true,
              )
            ],
          ),
        );
      }),
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        DataStorageScreen.route: (_) => const DataStorageScreen(),
        ConnectedAtsignsScreen.route: (_) => const ConnectedAtsignsScreen(),
        AppsScreen.route: (_) => const AppsScreen(),
        BrowseScreen.route: (_) => const BrowseScreen(),
        SettingsScreen.route: (_) => const SettingsScreen(),
      },
    );
  }

  void _goLocalData(context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _handleError(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(AppLocalizations.of(context)!.anErrorHasOccurred),
      ),
    );
    const Dialog();
  }
}
