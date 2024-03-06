import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/screens/add_goal.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/modules/shared/widgets/transitions.dart';

class MissingGoalTile extends StatelessWidget {
  const MissingGoalTile({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: CustomColor.white,
      strokeWidth: 1,
      dashPattern: const [6],
      strokeCap: StrokeCap.round,
      child: InkWell(
        onTap: () {
          rightSlideTransition(context, const AddGoal());
        },
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/add_circle.svg'),
              const SizedBox(width: 10),
              const Text(
                'Add a goal',
                style: TextStyle(
                  color: CustomColor.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
