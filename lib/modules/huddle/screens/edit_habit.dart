import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/huddle/widgets/checkbox.dart';
import 'package:routine_app/modules/huddle/widgets/color_tile.dart';
import 'package:routine_app/modules/huddle/widgets/habit_colors.dart';
import 'package:routine_app/shared/models/habit_model.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:routine_app/shared/widgets/snackbars.dart';

class EditHabit extends StatefulWidget {
  final String id;
  const EditHabit({
    super.key,
    required this.id,
  });

  @override
  State<EditHabit> createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late HabitModel habitModel;
  int _selectedColorIndex = 0;
  Color _selectdColor = habitsColor[0];

  final TextEditingController _habitName = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _selectedDate = DateTime.now();

  String timeFormat(TimeOfDay time) {
    final hours = time.hourOfPeriod;
    final minutes = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  timePicker() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: CustomColor.blue,
          ),
          // button colors
          buttonTheme: const ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: CustomColor.white,
            ),
          ),
        ),
        child: child ?? const SizedBox(),
      ),
      initialTime: const TimeOfDay(hour: 7, minute: 0),
    );
    if (timeOfDay != null) {
      _selectedTime = timeOfDay;
    }
    setState(() {});
  }

  datePicker() async {
    DateTime? dateTime = await showDatePicker(
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: CustomColor.blue,
          ),
          // button colors
          buttonTheme: const ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: CustomColor.white,
            ),
          ),
        ),
        child: child ?? const SizedBox(),
      ),
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 9999)),
    );
    if (dateTime != null) {
      _selectedDate = dateTime;
    }
    setState(() {});
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

  deleteHabit() async {
    DocumentSnapshot userHuddle =
        await FirebaseFirestore.instance.collection('huddles').doc(uid).get();
    if (userHuddle.exists) {
      Map data = userHuddle.data() as Map;
      List habits = data['habits'] ?? [];
      habits.remove(widget.id);
      try {
        FirebaseFirestore.instance
            .collection('huddles')
            .doc(uid)
            .collection('habits')
            .doc(widget.id)
            .delete()
            .then((value) => FirebaseFirestore.instance
                .collection('huddles')
                .doc(uid)
                .update({'habits': habits}))
            .then((value) => Navigator.pop(context));
      } catch (e) {
        errorSnackbar(context, 'Something went wrong. Please try again');
      }
    }
  }

  void deletePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete habit?',
            style: TextStyle(
              color: CustomColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: CustomColor.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        deleteHabit();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: CustomColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  changeHabit() async {
    Timestamp timestamp = createTimestamp(_selectedDate, _selectedTime);
    FirebaseFirestore.instance
        .collection('huddles')
        .doc(uid)
        .collection('habits')
        .doc(widget.id)
        .update({
      'color': habitsColor[_selectedColorIndex]
          .value
          .toRadixString(16)
          .toUpperCase(),
      'name': _habitName.text.trim(),
      'timestamp': timestamp,
    }).then((value) => Navigator.pop(context));
  }

  fetchHabitDetails() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('huddles')
        .doc(uid)
        .collection('habits')
        .doc(widget.id)
        .get();
    if (userDoc.exists) {
      Map data = userDoc.data() as Map;
      habitModel = HabitModel(
        name: data['name'],
        timestamp: data['timestamp'],
        color: data['color'] ?? habitsColor[0].value.toRadixString(16),
      );
      setState(() {
        _habitName.text = habitModel.toJson()['name'];
        _selectedTime = habitModel.toJson()['time'];
        _selectedDate = habitModel.toJson()['date'];
        _selectedColorIndex =
            habitsColor.indexOf(Color(habitModel.toJson()['color']));
        _selectdColor = habitsColor[_selectedColorIndex];
      });
    }
  }

  @override
  void initState() {
    fetchHabitDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '////${habitsColor[_selectedColorIndex].value.toRadixString(16).toUpperCase()}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/icons/back_circle.svg"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              deletePopup(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/delete.svg",
              height: 20,
            ),
          )
        ],
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
                      fillColor: _selectdColor.withOpacity(0.2),
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
                      backgroundColor: _selectdColor.withOpacity(0.5),
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
                      backgroundColor: _selectdColor.withOpacity(0.5),
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
                    'Color',
                    style: TextStyle(
                      color: CustomColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: habitsColor.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColorIndex = index;
                              _selectdColor = habitsColor[_selectedColorIndex];
                            });
                          },
                          child: ColorTile(
                            color: habitsColor[index],
                            trigger: _selectedColorIndex == index,
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
                        backgroundColor: _selectdColor,
                      ),
                      onPressed: () {
                        if (_habitName.text.trim().isEmpty) {
                          errorSnackbar(context, 'Name cannot be empty');
                        } else {
                          if (_habitName.text.trim().isNotEmpty) {
                            FocusManager.instance.primaryFocus!.unfocus();
                            changeHabit();
                          }
                        }
                      },
                      child: Text(
                        'Update Changes',
                        style: TextStyle(
                          color: _selectedColorIndex == 3
                              ? CustomColor.black
                              : CustomColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
