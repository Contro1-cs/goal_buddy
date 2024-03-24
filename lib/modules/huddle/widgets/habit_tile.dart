import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/huddle/screens/edit_habit.dart';
import 'package:routine_app/modules/huddle/widgets/checkbox.dart';
import 'package:routine_app/modules/huddle/widgets/habit_colors.dart';
import 'package:routine_app/shared/models/habit_model.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/shared/widgets/transitions.dart';

class HabitTile extends StatefulWidget {
  final String id;
  final String uid;
  final int index;
  const HabitTile({
    super.key,
    required this.id,
    required this.uid,
    required this.index,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

List<String> daysLabel = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

class _HabitTileState extends State<HabitTile> {
  bool todayTask = false;
  List weekView = List.generate(7, (index) => false);

  String timeFormat(TimeOfDay? time) {
    final hours = time!.hourOfPeriod;
    final minutes = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  String dateFormat(DateTime? date) {
    var difference = date!.difference(DateTime.now()).inDays;
    if (difference < 365) {
      return '${difference}d';
    } else {
      return '${(difference / 365.26).toStringAsFixed(1)}y';
    }
  }

  fetchWeekView() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('habits')
        .doc(widget.id)
        .get();
    if (userDoc.exists) {
      Map data = userDoc.data() as Map;

      DateTime now = DateTime.now();
      int dayIndex = (now.weekday + 6) % 7;
      setState(() {
        weekView = data['week'];
        todayTask = weekView[dayIndex];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeekView();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
          rightSlideTransition(
            context,
            EditHabit(
              id: widget.id,
            ),
          );
        }
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('huddles')
              .doc(widget.uid)
              .collection('habits')
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(height: 1);
            }
            Map data = snapshot.data!.data() as Map;
            HabitModel habitModel = HabitModel(
              name: data['name'],
              timestamp: data['timestamp'],
              color: data['color'] ?? habitsColor[0].value.toRadixString(16),
            );
            Color habitColor = Color(habitModel.toJson()['color']);
            Color secondaryColor =
                habitTickColor[habitsColor.indexOf(habitColor)];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: habitColor.withOpacity(0.2),
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
                          habitModel.toJson()['name'],
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
                              timeFormat(habitModel.toJson()['time']),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CustomColor.white,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              "assets/icons/calendar.svg",
                              color: CustomColor.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              dateFormat(habitModel.toJson()['date']),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.white,
                                  fontSize: 10),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        children: [
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: daysLabel.length,
                              itemBuilder: (context, index) {
                                DateTime now = DateTime.now();
                                int dayIndex = (now.weekday + 6) % 7;

                                Color tileColor = habitColor.withOpacity(0.2);
                                if ((index == dayIndex && todayTask) ||
                                    (index < dayIndex && weekView[index])) {
                                  tileColor = habitColor;
                                }

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color: tileColor,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        daysLabel[index],
                                        style: TextStyle(
                                          color: habitColor,
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
                            color: habitColor,
                            checkColor: secondaryColor,
                            trigger: todayTask,
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}
