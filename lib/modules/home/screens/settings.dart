import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/screens/reorder_habits.dart';
import 'package:routine_app/modules/home/widgets/settings_tab.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/shared/widgets/transitions.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: CustomColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/icons/back_circle.svg"),
        ),
      ),
      body: Column(
        children: [
          SettingsTab(
            icon: 'assets/icons/list.svg',
            title: 'Reorder Habits',
            onTap: () {
              rightSlideTransition(
                context,
                const ReorderHabits(),
              );
            },
          ),
          SettingsTab(icon: 'assets/icons/globe.svg', title: 'Website'),
          SettingsTab(icon: 'assets/icons/star.svg', title: 'Rate this app'),
          SettingsTab(
              icon: 'assets/icons/twitter.svg',
              title: 'Follow on Twitter',
              onTap: () async {
                try {
                  await launchUrl(Uri.parse("https://twitter.com/aaditya_fr"));
                } catch (e) {
                  print('/////$e');
                }
              }),
          SettingsTab(
              icon: 'assets/icons/delete_small.svg', title: 'Delete Profile'),
        ],
      ),
    );
  }
}
