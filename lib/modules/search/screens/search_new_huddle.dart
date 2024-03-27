import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/modules/home/widgets/huddle_tile.dart';
import 'package:routine_app/modules/search/screens/join_huddle.dart';
import 'package:routine_app/shared/models/huddle_model.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/shared/widgets/transitions.dart';

class SearchNewHuddle extends StatefulWidget {
  const SearchNewHuddle({super.key});

  @override
  State<SearchNewHuddle> createState() => _SearchNewHuddleState();
}

class _SearchNewHuddleState extends State<SearchNewHuddle> {
  TextEditingController _searchHuddleName = TextEditingController();
  List<HuddleModel> allHuddleData = [];
  List<HuddleModel> filteredHuddleList = [];

  void filterList(String query) {
    setState(() {
      filteredHuddleList = allHuddleData
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String participantsCountFormat(int number) {
    if (number < 999) {
      return number.toString();
    } else if (number >= 1000 && number <= 9999) {
      double formatted = number / 1000;
      return '${formatted.toStringAsFixed(1)}k';
    } else {
      double formatted = number / 1000;
      return '${formatted.floor().toString()}k';
    }
  }

  fetchHuddleList() async {
    QuerySnapshot huddles =
        await FirebaseFirestore.instance.collection('huddles').get();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (huddles.docs.isNotEmpty) {
      for (var e in huddles.docs) {
        if (e.id != uid) {
          allHuddleData.add(
            HuddleModel(
              id: e.id,
              habits: e['habits'],
              participants: e['participants'],
              name: e['name'],
              owner: e['owner'],
            ),
          );
        }
      }
      filteredHuddleList = allHuddleData;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchHuddleList();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchHuddleName,
              autocorrect: true,
              autofocus: true,
              style: const TextStyle(
                color: CustomColor.white,
                fontSize: 20,
              ),
              onChanged: (value) {
                filterList(value);
              },
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
              visible: filteredHuddleList.isEmpty,
              child: Expanded(
                child: Center(
                  child: Text(
                    "No huddle by the name - '${_searchHuddleName.text.trim()}'",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColor.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredHuddleList.length,
              itemBuilder: (context, index) {
                return HuddleTile(
                  title: filteredHuddleList[index].name,
                  personCount: participantsCountFormat(
                      filteredHuddleList[index].participants.length),
                  onTap: () {
                    rightSlideTransition(
                      context,
                      JoinHuddleScreen(
                        id: filteredHuddleList[index].id,
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
