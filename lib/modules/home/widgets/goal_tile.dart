import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routine_app/modules/home/screens/add_goal.dart';
import 'package:routine_app/modules/home/widgets/missing_goal_tile.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/modules/shared/widgets/transitions.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class GoalTile extends ConsumerStatefulWidget {
  const GoalTile({super.key});

  @override
  ConsumerState<GoalTile> createState() => _GoalTileState();
}

class _GoalTileState extends ConsumerState<GoalTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(userIdProvider).userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 50);
        }
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String? goal = data['goal'];
          if (goal == null) {
            return const MissingGoalTile();
          } else {
            return GestureDetector(
              onTap: () {
                rightSlideTransition(context, AddGoal(goalText: goal));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CustomColor.blue,
                ),
                child: Text(
                  goal,
                  style: const TextStyle(
                    color: CustomColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
