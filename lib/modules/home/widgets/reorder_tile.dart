import 'package:flutter/material.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class ReorderHabitTile extends StatelessWidget {
  final String title;
  const ReorderHabitTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: CustomColor.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: CustomColor.white),
          ),
          const Icon(
            Icons.drag_handle_rounded,
            color: CustomColor.white,
          )
        ],
      ),
    );
  }
}
