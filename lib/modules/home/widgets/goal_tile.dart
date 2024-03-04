import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';

class GoalTile extends StatelessWidget {
  const GoalTile({
    super.key,
    required this.title,
    required this.value,
    required this.label,
    required this.icon,
    required this.background,
  });
  final String title;
  final String value;
  final String label;
  final String icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SvgPicture.asset(
                  icon,
                  height: 20,
                  width: 20,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  softWrap: true,
                  style: const TextStyle(
                    height: 1,
                    color: CustomColor.white,
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Kg',
                  style: TextStyle(
                    color: CustomColor.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: background,
                border: Border.all(
                  color: CustomColor.black,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: CustomColor.black.withOpacity(.4),
                    offset: const Offset(0, 3),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: CustomColor.white,
                  fontSize: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
