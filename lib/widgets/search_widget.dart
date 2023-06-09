import 'package:at_data_browser/controllers/connected_atsigns_controller.dart';
import 'package:at_data_browser/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/apps_controller.dart';
import '../controllers/at_data_controller.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({required this.filter, super.key});

  final SearchWidgetFilter filter;

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  bool showClearIcon = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String value) async {
    switch (widget.filter) {
      case SearchWidgetFilter.apps:
        await ref.read(appsController.notifier).getFilteredConnectedApps(value);
        break;
      case SearchWidgetFilter.atSigns:
        await ref.read(connectedAtsignsControllerProvider.notifier).getFilteredConnectedAtsign(value);
        break;
    }
  }

  Future<void> _onPressed() async {
    ref.watch(filterControllerProvider.notifier).getFilteredAtData();
  }

  void _onTap() {
    if (!showClearIcon) {
      setState(() {
        showClearIcon = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.search,
              border: InputBorder.none,
              suffixIcon: showClearIcon
                  ? IconButton(
                      onPressed: () {
                        textEditingController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : const Icon(Icons.search),
            ),
            onChanged: _onChanged,
            onTap: _onTap,
          ),
        ),
      ),
    );
  }
}
