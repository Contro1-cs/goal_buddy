import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class SearchNewHuddle extends StatefulWidget {
  const SearchNewHuddle({super.key});

  @override
  State<SearchNewHuddle> createState() => _SearchNewHuddleState();
}

class _SearchNewHuddleState extends State<SearchNewHuddle> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              autocorrect: true,
              autofocus: true,
              style: const TextStyle(
                color: CustomColor.white,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                prefixIcon: SvgPicture.asset(
                  "assets/icons/search.svg",
                  fit: BoxFit.scaleDown,
                ),
                hintText: 'Search...',
                hintStyle: const TextStyle(
                  color: Color(0XFF6D7D8A),
                  fontSize: 20,
                ),
                filled: true,
                fillColor: CustomColor.blue.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            Visibility(
              child: Expanded(
                child: Center(
                  child: Text(
                    'Search any huddles from around the world',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColor.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
