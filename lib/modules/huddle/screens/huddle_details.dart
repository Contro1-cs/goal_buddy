import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class HuddleDetails extends StatefulWidget {
  final String id;
  final String? name;
  final int? index;
  const HuddleDetails({
    super.key,
    required this.id,
    this.name,
    this.index,
  });

  @override
  State<HuddleDetails> createState() => _HuddleDetailsState();
}

class _HuddleDetailsState extends State<HuddleDetails> {
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
      ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
