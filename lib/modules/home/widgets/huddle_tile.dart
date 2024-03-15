import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class HuddleTile extends StatelessWidget {
  final String title;
  final int count;
  final Function()? onTap;
  const HuddleTile({
    super.key,
    required this.title,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: CustomColor.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: CustomColor.blue, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: CustomColor.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/people.svg",
                    height: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    count.toString(),
                    style:
                        const TextStyle(color: CustomColor.white, fontSize: 14),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
