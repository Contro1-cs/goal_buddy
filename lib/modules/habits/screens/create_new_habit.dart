import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/habits/widget/day_tile.dart';
import 'package:intl/intl.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class CreateNewHabit extends ConsumerStatefulWidget {
  const CreateNewHabit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNewHabitState();
}

class _CreateNewHabitState extends ConsumerState<CreateNewHabit> {
  //Variables
  List daysBool = List.generate(7, (index) => true);
  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
  DateTime selectedDate = DateTime.now();
  bool nameError = false;
  bool _loading = false;

  //Controllers
  TextEditingController _nameController = TextEditingController();

  //Functions
  createNewTask() async {
    FirebaseFirestore.instance
        .collection('huddles')
        .doc(ref.watch(userIdProvider).userId)
        .update({
      "name": _nameController.text.trim(),
    });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          height: 150,
          decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 7, 0, 0),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                selectedTime = TimeOfDay.fromDateTime(newDateTime);
              });
            },
          ),
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          height: 150,
          decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CupertinoDatePicker(
            minimumDate: DateTime.now(),
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                selectedDate = newDateTime;
              });
            },
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatTime(int time) {
    if (time.toString().length == 1) {
      return '0$time';
    } else {
      return time.toString();
    }
  }

  String formatDate(String originalDate) {
    final DateFormat inputFormat = DateFormat('d-M-yyyy');
    final DateFormat outputFormat = DateFormat('dd MMM yyyy');
    DateTime parsedDate = inputFormat.parse(originalDate);
    return outputFormat.format(parsedDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/icons/back_circle.svg"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Create New Habit',
                    style: TextStyle(
                      color: CustomColor.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: CustomColor.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      hintText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: nameError ? 'Fill in your goal' : null,
                      filled: true,
                      fillColor: CustomColor.darkBlue,
                      hintStyle: const TextStyle(
                        color: Color(0XFF3A74A5),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  iconTitle("assets/icons/clock_done.svg", "Daily Reminder"),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _showTimePicker(context),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: CustomColor.darkBlue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${formatTime(selectedTime.hour)}:${formatTime(selectedTime.minute)}',
                        style: const TextStyle(color: CustomColor.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  iconTitle("assets/icons/target.svg", "Target"),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _showDatePicker(context),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: CustomColor.darkBlue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        formatDate(
                            '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}'),
                        style: const TextStyle(color: CustomColor.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  iconTitle("assets/icons/calendar_done.svg", "Days"),
                  const SizedBox(height: 6),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    height: 38,
                    child: ListView.builder(
                      itemCount: 7,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        List daysList = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return DayTile(
                          title: daysList[index],
                          trigger: daysBool[index],
                          onTap: () {
                            setState(() {
                              daysBool[index] = !daysBool[index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(height: 50),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.blue),
                      onPressed: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if (_nameController.text.trim().isEmpty) {
                          setState(() {
                            nameError = true;
                          });
                        } else if (!_loading) {
                          createNewTask();
                        }
                      },
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: CustomColor.white,
                              ),
                            )
                          : const Text(
                              'Commit New Habit',
                              style: TextStyle(
                                color: CustomColor.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

iconTitle(String icon, String title) {
  return Row(
    children: [
      SvgPicture.asset(icon),
      const SizedBox(width: 6),
      Text(
        title,
        style: const TextStyle(
          color: CustomColor.white,
          fontSize: 20,
        ),
      ),
    ],
  );
}
