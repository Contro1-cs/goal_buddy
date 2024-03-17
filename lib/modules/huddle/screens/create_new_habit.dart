import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:routine_app/shared/widgets/snackbars.dart';

class CreateNewHabit extends StatefulWidget {
  const CreateNewHabit({super.key});

  @override
  State<CreateNewHabit> createState() => _CreateNewHabitState();
}

class _CreateNewHabitState extends State<CreateNewHabit> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController _habitName = TextEditingController();
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  DateTime? _selectedDate = DateTime(DateTime.now().year, 12, 31);

  List<bool> daysBool = [];

  List<String> days = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];
  @override
  void initState() {
    daysBool = List.generate(days.length, (index) => true);
    super.initState();
  }

  String timeFormat(TimeOfDay? time) {
    final hours = time!.hourOfPeriod;
    final minutes = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  timePicker() async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 0),
    );
  }

  datePicker() async {
    _selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 9999)),
    );
  }

  Timestamp createTimestamp(DateTime? date, TimeOfDay? time) {
    final DateTime combinedDateTime = DateTime(
      date!.year,
      date.month,
      date.day,
      time!.hour,
      time.minute,
    );

    return Timestamp.fromDate(combinedDateTime);
  }

  newHabit() async {
    DocumentSnapshot userHuddle =
        await FirebaseFirestore.instance.collection('huddles').doc(uid).get();
    Timestamp timestamp = createTimestamp(_selectedDate, _selectedTime);
    if (userHuddle.exists) {
      print('////Create new habit');
      Map data = userHuddle.data() as Map;
      List habits = data['habits'] ?? [];
      habits.add({
        'name': _habitName.text.trim(),
        'timestamp': timestamp,
        'days': daysBool,
      });
      try {
        FirebaseFirestore.instance
            .collection('huddles')
            .doc(uid)
            .update({'habits': habits}).then((value) => Navigator.pop(context));
      } catch (e) {
        print('//////${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/icons/back_circle.svg"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    maxLines: null,
                    maxLength: 25,
                    controller: _habitName,
                    style: const TextStyle(
                      color: CustomColor.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Untitled',
                      hintStyle: TextStyle(
                        color: CustomColor.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: CustomColor.blue.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      counterStyle: const TextStyle(color: CustomColor.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Time',
                    style: TextStyle(
                      color: CustomColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: CustomColor.blue,
                    ),
                    onPressed: () {
                      timePicker();
                    },
                    child: Text(
                      timeFormat(_selectedTime),
                      style: const TextStyle(
                        color: CustomColor.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Target',
                    style: TextStyle(
                      color: CustomColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: CustomColor.blue,
                    ),
                    onPressed: () {
                      datePicker();
                    },
                    child: Text(
                      DateFormat('dd MMM yyyy')
                          .format(_selectedDate ?? DateTime.now()),
                      style: const TextStyle(
                        color: CustomColor.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Days',
                    style: TextStyle(
                      color: CustomColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              daysBool[index] = !daysBool[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: daysBool[index]
                                  ? CustomColor.blue
                                  : Colors.transparent,
                            ),
                            child: Text(
                              days[index],
                              style: const TextStyle(color: CustomColor.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Expanded(child: SizedBox(height: 50)),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: CustomColor.green),
                      onPressed: () {
                        if (_habitName.text.trim().isEmpty) {
                          errorSnackbar(context, 'Name cannot be empty');
                        } else {
                          List<bool> allFalse =
                              List.generate(days.length, (index) => false);

                          if (daysBool == allFalse) {
                            errorSnackbar(context, 'Select days for habit');
                          } else {
                            FocusManager.instance.primaryFocus!.unfocus();
                            newHabit();
                          }
                        }
                      },
                      child: const Text(
                        'Commit New Habit',
                        style: TextStyle(
                          color: CustomColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
