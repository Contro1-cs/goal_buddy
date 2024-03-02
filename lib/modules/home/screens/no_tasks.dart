import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/habits/screens/create_new_habit.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/modules/shared/widgets/transitions.dart';

class NoTasks extends StatelessWidget {
  const NoTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rightSlideTransition(context, const CreateNewHabit());
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/home_illustration.svg"),
            const SizedBox(height: 20),
            const Text(
              'Tap anywhere to get stared',
              style: TextStyle(
                color: CustomColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
