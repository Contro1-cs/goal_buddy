import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class SettingsTab extends StatelessWidget {
  final String icon;
  final String title;
  final Function()? onTap;
  const SettingsTab({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomColor.white.withOpacity(0.1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: title.toLowerCase() == 'follow on twitter'
                    ? CustomColor.blue
                    : title.toLowerCase() == 'delete profile'
                        ? CustomColor.red
                        : CustomColor.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
