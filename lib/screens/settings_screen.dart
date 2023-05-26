import 'package:at_backupkey_flutter/at_backupkey_flutter.dart';
import 'package:at_contacts_flutter/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/navigation_service.dart';
import '../utils/constants.dart';
import '../widgets/reset_app_button.dart';
import '../widgets/settings_button.dart';
import '../widgets/switch_atsign.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static String route = 'settingsScreen';
  final appPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 74,
        leading: Padding(
          padding: EdgeInsets.all(appPadding),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: kBrowserColor),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: kBrowserColor, fontWeight: FontWeight.w600),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: appPadding),
          child: Text(
            strings.settings,
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   ContactService().currentAtsign,
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
            // Text(
            //   ContactService().loggedInUserDetails!.tags!['name'] ?? '',
            //   style: Theme.of(context).textTheme.displaySmall,
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // SettingsButton(
            //   icon: Icons.block_outlined,
            //   title: 'Blocked Contacts',
            //   onTap: () {
            //     Navigator.of(context).pushNamed(CustomBlockedScreen.routeName);
            //   },
            // ),
            const SizedBox(
              height: 59,
            ),
            SettingsButton(
              icon: Icons.bookmark_outline,
              title: strings.backupYourKeys,
              onTap: () {
                BackupKeyWidget(atsign: ContactService().currentAtsign)
                    .showBackupDialog(context);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SettingsButton(
              icon: Icons.logout_rounded,
              title: strings.switchAtsign,
              onTap: () async {
                await showModalBottomSheet(
                    context: NavigationService.navKey.currentContext!,
                    builder: (context) => const AtSignBottomSheet());
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const ResetAppButton(),
            const SizedBox(
              height: 34,
            ),
            SettingsButton(
              icon: Icons.help_center_outlined,
              title: strings.faq,
              onTap: () async {
                final Uri url = Uri.parse('https://atsign.com/faqs/');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SettingsButton(
              icon: Icons.forum_outlined,
              title: strings.contactUs,
              onTap: () async {
                Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'atdude@atsign.com',
                );
                if (!await launchUrl(emailUri)) {
                  throw Exception('Could not launch $emailUri');
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SettingsButton(
              icon: Icons.account_balance_wallet_outlined,
              title: strings.privacyPolicy,
              onTap: () async {
                final Uri url =
                    Uri.parse('https://atsign.com/apps/atDude-privacy/');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
