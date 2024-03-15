import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/widgets/huddle_tile.dart';
import 'package:routine_app/modules/huddle/screens/huddle_details.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:routine_app/shared/widgets/transitions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  String id = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColor.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Goal',
              style: TextStyle(
                color: CustomColor.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Buddy',
              style: TextStyle(
                color: CustomColor.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('huddles')
                    .doc(id)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Unable to fetch your huddle',
                          style: TextStyle(
                            color: CustomColor.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 1,
                      width: 1,
                    );
                  }
                  ;
                  Map data = snapshot.data!.data() as Map;
                  List participants = data['participants'] ?? [];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Huddle',
                        style: TextStyle(
                          color: CustomColor.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      HuddleTile(
                        title: data['name'],
                        count: participants.length,
                        onTap: () {
                          rightSlideTransition(
                            context,
                            HuddleDetails(id: snapshot.data!.id),
                          );
                        },
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Other Huddles',
                  style: TextStyle(
                    color: CustomColor.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  color: CustomColor.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/add_circle.svg",
                          height: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "New Huddle",
                          style: TextStyle(
                            fontSize: 10,
                            color: CustomColor.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection('users').doc(id).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Map data = snapshot.data!.data() as Map;
                List huddles = data['huddles'];
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: huddles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        huddles[index],
                        style: TextStyle(color: CustomColor.white),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
