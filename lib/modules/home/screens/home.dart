import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/screens/settings.dart';
import 'package:routine_app/modules/home/widgets/huddle_tile.dart';
import 'package:routine_app/modules/huddle/screens/my_huddle_details.dart';
import 'package:routine_app/modules/huddle/screens/other_huddle_details.dart';
import 'package:routine_app/modules/search/screens/search_new_huddle.dart';
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
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () {
              upSlideTransition(context, const SettingsPage());
            },
            icon: SvgPicture.asset(
              "assets/icons/settings.svg",
              height: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('huddles')
                    .doc(id)
                    .snapshots(),
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
                    return const SizedBox(height: 1, width: 1);
                  }

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
                        personCount: participants.length.toString(),
                        onTap: () {
                          rightSlideTransition(
                            context,
                            const MyHuddleDetails(),
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
                InkWell(
                  onTap: () {
                    rightSlideTransition(context, const SearchNewHuddle());
                  },
                  child: DottedBorder(
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
                ),
              ],
            ),
            const SizedBox(height: 5),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Map data = snapshot.data!.data() as Map;
                List huddles = data['huddles'];
                return huddles.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No Huddles joined',
                            style: TextStyle(
                              color: CustomColor.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: huddles.length,
                        itemBuilder: (context, index) {
                          return HuddleTile(
                            title: huddles[index]['name'],
                            targetCount: '12',
                            onTap: () {
                              rightSlideTransition(
                                context,
                                OtherHuddleDetails(
                                  id: huddles[index]['id'],
                                  name: huddles[index]['name'],
                                  index: index,
                                ),
                              );
                            },
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
