import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/habits/screens/create_new_huddle.dart';
import 'package:routine_app/modules/home/screens/no_tasks.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //Variables
  Map<String, dynamic> groups = {};

  //Functions
  initId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    final allInfo = deviceInfo.androidId;
    ref.read(userIdProvider).setUserId(allInfo);
  }

  @override
  void initState() {
    initId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.black,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Goal',
              style: TextStyle(
                color: CustomColor.white,
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/settings.svg",
              height: 20,
              width: 20,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/menu.svg",
            height: 20,
            width: 20,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('huddles')
            .doc(ref.watch(userIdProvider).userId.isEmpty
                ? 'a'
                : ref.watch(userIdProvider).userId)
            .snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.exists) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              if (data.isEmpty) {
                return const CreateNewHuddle();
              }
              return const HomeScreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          } catch (e) {
            return Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: CustomColor.red),
              ),
            );
          }
        },
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('huddles')
            .doc(ref.watch(userIdProvider).userId)
            .collection('habits')
            .snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> data = snapshot.data!.docs;
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'This is your huddle',
                      style: TextStyle(
                        color: CustomColor.white,
                        fontSize: 24,
                      ),
                    ),
                    const Text(
                      'Start by creating new habit',
                      style: TextStyle(
                        color: CustomColor.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SvgPicture.asset("assets/icons/add_circle.svg")
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          } catch (e) {
            return Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: CustomColor.red),
              ),
            );
          }
        },
      ),
    );
  }
}

// Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             //Goals Tile
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Goals',
//                   style: TextStyle(
//                     color: CustomColor.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GoalTile(
//                       title: 'Weight',
//                       value: '55',
//                       label: 'Keep Cumming',
//                       icon: SvgPicture.asset('assets/icons/weight_scale.svg'),
//                       background: CustomColor.blue,
//                     ),
//                     const SizedBox(width: 10),
//                     GoalTile(
//                       title: 'Goal',
//                       value: '70',
//                       label: '15Kg left',
//                       icon: SvgPicture.asset('assets/icons/target.svg'),
//                       background: CustomColor.green,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Divider(
//               height: 30,
//               color: CustomColor.white.withOpacity(0.4),
//               indent: 50,
//               endIndent: 50,
//             ),

//             //Tasks
//             const Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Tasks',
//                   style: TextStyle(
//                     color: CustomColor.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 HabitTile(),
//               ],
//             ),
//           ],
//         ),
//       ),
