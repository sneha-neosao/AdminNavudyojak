import 'package:admin_navudyojak/src/features/settings/widgets/alert_preferences_card_widget.dart';
import 'package:admin_navudyojak/src/features/settings/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import 'account_actions_card_widget.dart';

class SettingsContentWidget extends StatelessWidget {
  const SettingsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.hS,
          const ProfileHeaderWidget(),
          16.hS,
          const AlertPreferencesCardWidget(),
          16.hS,
          const AccountActionsCardWidget(),
          24.hS,
        ],
      ),
    );
  }
}
