import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/huddle/screens/create_new_habit.dart';
import 'package:routine_app/modules/huddle/widgets/habit_tile.dart';
import 'package:routine_app/shared/models/habit_model.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/shared/widgets/transitions.dart';

class MyHuddleDetails extends StatefulWidget {
  final String id;
  final String? name;
  final int? index;
  const MyHuddleDetails({
    super.key,
    required this.id,
    this.name,
    this.index,
  });

  @override
  State<MyHuddleDetails> createState() => _MyHuddleDetailsState();
}

class _MyHuddleDetailsState extends State<MyHuddleDetails> {
  final TextEditingController _myHuddleController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool updateName = false;

  changeName() async {
    FirebaseFirestore.instance
        .collection('huddles')
        .doc(widget.id)
        .update({"name": _myHuddleController.text.trim()});
  }

  changePersonalName(String name) async {
    if (widget.index != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Map data = userDoc.data() as Map;
      List huddles = data['huddles'];

      huddles[widget.index ?? 99] = {
        "name": name,
        "id": widget.id,
      };
      FirebaseFirestore.instance.collection('users').doc(uid).update(
          {'huddles': huddles}).then((value) => print('////Name Changed'));
    }
  }

  @override
  void dispose() {
    changeName();
    super.dispose();
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
        actions: [
          Visibility(
            visible: widget.id == uid,
            child: IconButton(
              padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
              onPressed: () {
                upSlideTransition(context, const CreateNewHabit());
              },
              icon: SvgPicture.asset("assets/icons/plus.svg"),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('huddles')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          List<HabitModel> habits = [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map data = snapshot.data!.data() as Map;
          _myHuddleController.text = data['name'];
          for (var e in data['habits']) {
            habits.add(
              HabitModel(
                name: e['name'],
                timestamp: e['timestamp'],
                days: e['days'],
              ),
            );
          }
          if (data['name'] != widget.name) {
            changePersonalName(data['name']);
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return TextField(
                              enabled: widget.id == uid,
                              maxLines: null,
                              maxLength: 25,
                              onTap: () {
                                setState(() {
                                  updateName = true;
                                });
                              },
                              onSubmitted: (value) => changeName(),
                              style: const TextStyle(
                                color: CustomColor.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                              controller: _myHuddleController,
                              decoration: InputDecoration(
                                filled: true,
                                suffixIcon: updateName
                                    ? IconButton(
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          changeName();
                                          setState(() {
                                            updateName = false;
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/icons/check_circle.svg",
                                        ),
                                      )
                                    : null,
                                fillColor: CustomColor.blue.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                counterText: updateName ? null : '',
                                counterStyle:
                                    const TextStyle(color: CustomColor.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      color: CustomColor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      String name = habits[index].toJson()['name'];
                      TimeOfDay time = habits[index].toJson()['time'];
                      DateTime date = habits[index].toJson()['date'];
                      List days = habits[index].toJson()['days'];
                      return HabitTile(
                        id: widget.id,
                        index: index,
                        name: name,
                        date: date,
                        time: time,
                        days: days,
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
