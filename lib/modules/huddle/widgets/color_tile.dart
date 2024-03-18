import 'package:flutter/material.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class ColorTile extends StatelessWidget {
  final Color color;
  final bool trigger;
  const ColorTile({
    super.key,
    required this.color,
    required this.trigger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: trigger ? 60 : 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: trigger ? CustomColor.black : Colors.transparent,
        ),
      ),
    );
  }
}
