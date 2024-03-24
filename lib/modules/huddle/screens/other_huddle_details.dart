import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/huddle/widgets/habit_tile.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/shared/widgets/snackbars.dart';

class OtherHuddleDetails extends StatefulWidget {
  final String id;
  final String? name;
  final int? index;
  const OtherHuddleDetails({
    super.key,
    required this.id,
    this.name,
    this.index,
  });

  @override
  State<OtherHuddleDetails> createState() => _OtherHuddleDetailsState();
}

class _OtherHuddleDetailsState extends State<OtherHuddleDetails> {
  final TextEditingController _myHuddleController = TextEditingController();
  bool updateName = false;

  changePersonalName(String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (widget.index != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Map data = userDoc.data() as Map;
      List huddles = data['huddles'];

      huddles[widget.index ?? 99] = {
        "name": name,
        "id": widget.id,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'huddles': huddles});
    }
  }

  leaveHuddle() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map data = userDoc.data() as Map;
    List huddles = data['huddles'];
    huddles.removeWhere((element) => element['id'] == widget.id);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"huddles": huddles}).then((value) => Navigator.pop(context));
  }

  void leveeHuddlePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Leave this huddle?',
            style: TextStyle(
              color: CustomColor.black,
              fontSize: 18,
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
                        leaveHuddle();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Leave',
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
            onPressed: () {
              leveeHuddlePopup(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/logout.svg",
              height: 20,
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map data = snapshot.data!.data() as Map;
          if (data['name'] != widget.name) {
            changePersonalName(data['name']);
          }
          _myHuddleController.text = data['name'];
          List habits = data['habits'];
          String ownerId = data['owner'];

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
                              enabled: false,
                              maxLines: null,
                              maxLength: 25,
                              onTap: () {
                                setState(() {
                                  updateName = true;
                                });
                              },
                              style: const TextStyle(
                                color: CustomColor.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                              controller: _myHuddleController,
                              decoration: InputDecoration(
                                filled: true,
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
                  Expanded(
                    child: habits.isEmpty
                        ? const Center(
                            child: Text('No habits found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              return HabitTile(
                                id: habits[index],
                                uid: ownerId,
                                index: index,
                              );
                            },
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
