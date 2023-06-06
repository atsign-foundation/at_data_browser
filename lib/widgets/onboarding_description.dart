import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardignDescription extends StatelessWidget {
  const OnboardignDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          strings.onboardingTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Text(
          strings.onboardingDesc,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
