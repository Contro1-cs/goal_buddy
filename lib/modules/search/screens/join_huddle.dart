import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/models/habit_model.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class JoinHuddleScreen extends StatelessWidget {
  final String id;
  const JoinHuddleScreen({
    super.key,
    required this.id,
  });

  joinHuddle(context, String id, String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      Map data = userDoc.data() as Map;
      List userHuddles = data['huddles'];
      userHuddles.add({"id": id, "name": name});
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"huddles": userHuddles}).then(
        (value) {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('huddles').doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map data = snapshot.data!.data() as Map;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: CustomColor.black,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset("assets/icons/back_circle.svg"),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(
                      color: CustomColor.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('huddles')
                            .doc(id)
                            .collection('habits')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }
                          List data = snapshot.data!.docs;
                          List<HabitModel> habitsList = [];
                          for (var e in data) {
                            habitsList.add(
                              HabitModel(
                                name: e['name'],
                                timestamp: e['timestamp'],
                                color: e['color'],
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 2,
                            ),
                            itemCount: habitsList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      Color(habitsList[index].toJson()['color'])
                                          .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 40,
                                ),
                                child: Text(
                                  habitsList[index].name,
                                  textAlign: TextAlign.center,
                                  style:
                                      const TextStyle(color: CustomColor.white),
                                ),
                              );
                            },
                          );
                        }),
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: CustomColor.green,
                      ),
                      onPressed: () {
                        joinHuddle(context, id, data['name']);
                      },
                      child: const Text(
                        'Join Huddle',
                        style: TextStyle(
                          color: CustomColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
