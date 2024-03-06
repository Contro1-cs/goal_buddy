import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class AddGoal extends ConsumerStatefulWidget {
  const AddGoal({super.key, this.goalText});
  final String? goalText;

  @override
  ConsumerState<AddGoal> createState() => _NoHuddleState();
}

class _NoHuddleState extends ConsumerState<AddGoal> {
  bool huddleError = false;
  bool _loading = false;
  int goalLength = 0;

  //Controllers
  TextEditingController _goalController = TextEditingController();

  //Functions
  createNewGoal() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(userIdProvider).userId)
        .update({
      "goal": _goalController.text.trim(),
    }).then(
      (value) => Navigator.pop(context),
    );
  }

  @override
  void initState() {
    _goalController.text = widget.goalText ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/icons/back_circle.svg"),
        ),
        centerTitle: true,
        title: const Text(
          'Set a goal',
          style: TextStyle(
            color: CustomColor.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Your goal',
              style: TextStyle(
                color: CustomColor.white,
                fontSize: 20,
              ),
            ),
            const Text(
              'You goal will always be on the top of your screen',
              style: TextStyle(
                color: Color(0XFF3E637A),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalController,
              maxLength: 100,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  goalLength = value.length;
                });
              },
              style: const TextStyle(color: CustomColor.white),
              autofocus: true,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                counterStyle: TextStyle(
                  color: goalLength < 50
                      ? CustomColor.green
                      : goalLength < 90
                          ? CustomColor.yellow
                          : CustomColor.red,
                ),
                hintText: 'Name',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: huddleError ? 'Name of your Huddle' : null,
                filled: true,
                fillColor: CustomColor.darkBlue,
                hintStyle: const TextStyle(
                  color: Color(0XFF3A74A5),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Expanded(
              child: SizedBox(height: 30),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: CustomColor.blue),
                onPressed: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  if (_goalController.text.trim().isEmpty) {
                    setState(() {
                      huddleError = true;
                    });
                  } else if (!_loading) {
                    createNewGoal();
                  }
                },
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: CustomColor.white,
                        ),
                      )
                    : const Text(
                        'Set your goal',
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
    );
  }
}
