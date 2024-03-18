import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/huddle/screens/create_new_habit.dart';
import 'package:routine_app/modules/huddle/widgets/habit_tile.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/shared/widgets/transitions.dart';

class MyHuddleDetails extends StatefulWidget {
  final String? name;
  final int? index;
  const MyHuddleDetails({
    super.key,
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

  // changeName() async {}

  @override
  void dispose() {
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
          IconButton(
            padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
            onPressed: () {
              upSlideTransition(context, const CreateNewHabit());
            },
            icon: SvgPicture.asset("assets/icons/plus.svg"),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('huddles')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map data = snapshot.data!.data() as Map;
          _myHuddleController.text = data['name'] ?? '';
          List habitsOrder = [];

          habitsOrder = data['habits'] ?? [];

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
                              maxLines: null,
                              maxLength: 25,
                              onTap: () {
                                setState(() {
                                  updateName = true;
                                });
                              },
                              // onSubmitted: (value) => changeName(),
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
                                          // changeName();
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
                  (habitsOrder.isEmpty)
                      ? const Center(
                          child: Text(
                            'No habits found',
                            style: TextStyle(color: CustomColor.white),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: habitsOrder.length,
                          itemBuilder: (context, index) {
                            String id = habitsOrder[index];
                            return HabitTile(id: id, index: index);
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
