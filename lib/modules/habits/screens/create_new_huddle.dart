import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/habits/screens/create_new_habit.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/modules/shared/widgets/snackbars.dart';
import 'package:routine_app/modules/shared/widgets/transitions.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class CreateNewHuddle extends ConsumerStatefulWidget {
  const CreateNewHuddle({super.key});

  @override
  ConsumerState<CreateNewHuddle> createState() => _NoHuddleState();
}

class _NoHuddleState extends ConsumerState<CreateNewHuddle> {
  bool huddleError = false;
  bool _loading = false;

  //Controllers
  TextEditingController _huddleController = TextEditingController();

  //Functions
  createNewHuddle() {
    setState(() {
      _loading = true;
    });
    FirebaseFirestore.instance
        .collection('huddles')
        .doc(ref.watch(userIdProvider).userId)
        .set({
      "name": _huddleController.text.trim(),
    }).then((value) {
      rightSlideTransition(
        context,
        const CreateNewHabit(),
      );
    }).onError(
      (error, stackTrace) => errorSnackbar(
        context,
        error.toString(),
      ),
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _huddleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Your Huddle',
              style: TextStyle(
                color: CustomColor.white,
                fontSize: 20,
              ),
            ),
            const Text(
              'You will be able to share this huddle with your buddies!',
              style: TextStyle(
                color: Color(0XFF3E637A),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _huddleController,
              style: const TextStyle(
                color: CustomColor.white,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  if (_huddleController.text.trim().isEmpty) {
                    setState(() {
                      huddleError = true;
                    });
                  } else if (!_loading) {
                    createNewHuddle();
                  }
                },
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: CustomColor.white,
                        ),
                      )
                    : const Text(
                        'Create Your Huddle',
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
