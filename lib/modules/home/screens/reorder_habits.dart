import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/widgets/reorder_tile.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class ReorderHabits extends StatefulWidget {
  const ReorderHabits({super.key});

  @override
  State<ReorderHabits> createState() => _ReorderHabitsState();
}

List habits = [];

class _ReorderHabitsState extends State<ReorderHabits> {
  fetchHabits() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot myHuddle =
        await FirebaseFirestore.instance.collection('huddles').doc(uid).get();
    if (myHuddle.exists) {
      Map data = myHuddle.data() as Map;
      setState(() {
        habits = data['habits'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Reorder Habits',
          style: TextStyle(
            color: CustomColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/icons/back_circle.svg"),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: habits.isEmpty
                ? Center(
                    child: Text(
                      'No habits found',
                      style: TextStyle(
                        color: CustomColor.white.withOpacity(0.5),
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      return ReorderHabitTile(
                        key: Key(index.toString()),
                        title: habits[index],
                      );
                    },
                    itemCount: habits.length,
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final String item = habits.removeAt(oldIndex);
                      habits.insert(newIndex, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
