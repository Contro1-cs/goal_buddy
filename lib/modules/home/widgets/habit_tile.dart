import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/shared/models/habit_day_model.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';

class HabitTile extends StatefulWidget {
  const HabitTile({super.key});

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  bool selected = false;
  List<HabitDayModel> dayModels = [
    HabitDayModel(day: 'M', status: 'success'),
    HabitDayModel(day: 'T', status: 'failed'),
    HabitDayModel(day: 'W', status: 'na'),
    HabitDayModel(day: 'T', status: 'failed'),
    HabitDayModel(day: 'F', status: 'na'),
    HabitDayModel(day: 'S', status: 'success'),
    HabitDayModel(day: 'S', status: 'success'),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomColor.blue.withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Left
              //Title, freq, time
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gym Workout',
                    style: TextStyle(
                      color: CustomColor.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/calendar.svg",
                            height: 10,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            'Daily',
                            style: TextStyle(
                              color: CustomColor.blue,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/clock.svg",
                            height: 10,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            '45 Min',
                            style: TextStyle(
                              color: CustomColor.blue,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              //Middle
              //Weekly view
              Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: dayModels.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return dayStatus(dayModels[index]);
                    },
                  ),
                ),
              ),

              //Right
              //Checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = !selected;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selected
                        ? CustomColor.blue
                        : CustomColor.blue.withOpacity(0),
                    border: Border.all(color: CustomColor.blue),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.done_rounded,
                      size: 16,
                      color: selected ? CustomColor.white : CustomColor.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

dayStatus(HabitDayModel dayModel) {
  Color tileColor = CustomColor.white.withOpacity(0.2);
  if (dayModel.status == 'success') {
    tileColor = CustomColor.blue;
  } else if (dayModel.status == 'failed') {
    tileColor = CustomColor.red;
  } else {
    tileColor = CustomColor.white.withOpacity(0.2);
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 10,
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      Text(
        dayModel.day.toUpperCase(),
        style: const TextStyle(
          color: CustomColor.white,
          fontSize: 8,
        ),
      ),
    ],
  );
}
