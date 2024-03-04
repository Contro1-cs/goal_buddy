import 'package:flutter/material.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';

class DayTile extends StatelessWidget {
  const DayTile({
    super.key,
    required this.title,
    required this.trigger,
    required this.onTap,
  });
  final String title;
  final bool trigger;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: trigger ? CustomColor.darkBlue : Colors.transparent,
        ),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: CustomColor.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
