import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:routine_app/modules/huddle/screens/edit_habit.dart';
import 'package:routine_app/modules/huddle/widgets/checkbox.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class HabitTile extends StatefulWidget {
  final String id;
  final int index;
  final String name;
  final TimeOfDay time;
  final DateTime date;
  final List days;
  const HabitTile({
    super.key,
    required this.id,
    required this.index,
    required this.name,
    required this.time,
    required this.date,
    required this.days,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

List<String> daysLabel = [
  'M',
  'T',
  'W',
  'T',
  'F',
  'S',
  'S',
];

class _HabitTileState extends State<HabitTile> {
  bool todayTask = false;

  String timeFormat(TimeOfDay? time) {
    final hours = time!.hourOfPeriod;
    final minutes = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  String dateFormat(DateTime? date) {
    return DateFormat('dd MMM yyyy').format(date ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditHabit(
            id: widget.id,
            index: widget.index,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: CustomColor.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: CustomColor.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/clock.svg",
                        color: CustomColor.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        timeFormat(widget.time),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: CustomColor.white,
                            fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: daysLabel.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 10,
                            decoration: BoxDecoration(
                              color: widget.days[index]
                                  ? CustomColor.blue
                                  : CustomColor.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Text(
                          daysLabel[index],
                          style: const TextStyle(
                            color: CustomColor.white,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            CustomCheckBox(
              onTap: () {
                setState(() {
                  todayTask = !todayTask;
                });
              },
              trigger: todayTask,
            ),
          ],
        ),
      ),
    );
  }
}
