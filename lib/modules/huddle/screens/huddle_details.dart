import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class HuddleDetails extends StatefulWidget {
  final String id;
  const HuddleDetails({super.key, required this.id});

  @override
  State<HuddleDetails> createState() => _HuddleDetailsState();
}

class _HuddleDetailsState extends State<HuddleDetails> {
  TextEditingController _myHuddleController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('huddles')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map data = snapshot.data!.data() as Map;
          _myHuddleController.text = data['name'];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColor.blue.withOpacity(0.1),
                    ),
                    child: TextField(
                      style: const TextStyle(
                        color: CustomColor.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _myHuddleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
