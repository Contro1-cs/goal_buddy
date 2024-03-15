import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/screens/home.dart';
import 'package:routine_app/riverpod/riverpod.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class BotNavBar extends ConsumerStatefulWidget {
  const BotNavBar({super.key});

  @override
  ConsumerState<BotNavBar> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<BotNavBar> {
  List<Widget> screens = [
    const HomePage(),
    const HomePage(),
    const HomePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[ref.watch(navBarProvider).currentIndex],
      bottomNavigationBar: Container(
        height: 65,
        margin: const EdgeInsets.fromLTRB(16, 2, 16, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0XFF353535),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                ref.read(navBarProvider.notifier).changeCurrentIndex(0);
              },
              icon: ref.watch(navBarProvider).currentIndex == 0
                  ? SvgPicture.asset(
                      "assets/navbar/home_active.svg",
                    )
                  : SvgPicture.asset(
                      "assets/navbar/home_icon.svg",
                    ),
            ),
            IconButton(
              onPressed: () {
                ref.read(navBarProvider.notifier).changeCurrentIndex(1);
              },
              icon: ref.watch(navBarProvider).currentIndex == 1
                  ? SvgPicture.asset(
                      "assets/navbar/people_active.svg",
                    )
                  : SvgPicture.asset(
                      "assets/navbar/people_icon.svg",
                    ),
            ),
            IconButton(
              onPressed: () {
                ref.read(navBarProvider.notifier).changeCurrentIndex(2);
              },
              icon: ref.watch(navBarProvider).currentIndex == 2
                  ? SvgPicture.asset(
                      "assets/navbar/profile_active.svg",
                    )
                  : SvgPicture.asset(
                      "assets/navbar/profile_icon.svg",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
