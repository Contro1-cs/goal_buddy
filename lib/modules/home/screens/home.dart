import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/habits/screens/create_new_habit.dart';
import 'package:routine_app/modules/habits/screens/create_new_huddle.dart';
import 'package:routine_app/modules/home/screens/all_listed_habits.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/modules/shared/widgets/transitions.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //Variables
  Map<String, dynamic> groups = {};
  List habitsList = [];

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
              habitsList = data['habits'] ?? [];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (data.isEmpty) {
                return const CreateNewHuddle();
              }
              if (habitsList.isEmpty) {
                return const NoHabitsScreen();
              }
              return const AllListedHabits();
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

class NoHabitsScreen extends ConsumerStatefulWidget {
  const NoHabitsScreen({super.key});

  @override
  ConsumerState<NoHabitsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<NoHabitsScreen> {
  @override
  Widget build(BuildContext context) {
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
          IconButton(
            onPressed: () {
              rightSlideTransition(
                context,
                const CreateNewHabit(),
              );
            },
            icon: SvgPicture.asset("assets/icons/add_circle.svg"),
          ),
        ],
      ),
    );
  }
}