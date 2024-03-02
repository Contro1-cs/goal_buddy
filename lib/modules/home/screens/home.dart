import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/screens/no_tasks.dart';
import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(
      () async {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        final allInfo = deviceInfo.androidId;
        ref.read(userIdProvider).checkUserId(allInfo);
      },
    );

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
      body: const NoTasks(),
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