import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/widgets/goal_tile.dart';
import 'package:routine_app/modules/home/widgets/habit_tile.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';

class AllListedHabits extends StatefulWidget {
  const AllListedHabits({super.key});

  @override
  State<AllListedHabits> createState() => _AllListedHabitsState();
}

class _AllListedHabitsState extends State<AllListedHabits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            //Goals Tile
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goals',
                  style: TextStyle(
                    color: CustomColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GoalTile(
                      title: 'Weight',
                      value: '55',
                      label: 'Keep Cumming',
                      icon: 'assets/icons/weight_scale.svg',
                      background: CustomColor.blue,
                    ),
                    SizedBox(width: 10),
                    GoalTile(
                      title: 'Goal',
                      value: '70',
                      label: '15Kg left',
                      icon: 'assets/icons/target.svg',
                      background: CustomColor.green,
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 30,
              color: CustomColor.white.withOpacity(0.4),
              indent: 50,
              endIndent: 50,
            ),

            //Tasks
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks',
                  style: TextStyle(
                    color: CustomColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                HabitTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
