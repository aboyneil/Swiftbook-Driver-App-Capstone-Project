import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/navBar/tabNavigator.dart';
import 'package:swiftbook/styles/style.dart';

class PageOptions extends StatefulWidget {

  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  String currentPage = "Upcoming";
  List<String> pageKeys = ["Upcoming", "Ongoing", "Completed"];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "Upcoming": GlobalKey<NavigatorState>(),
    "Ongoing": GlobalKey<NavigatorState>(),
    "Completed": GlobalKey<NavigatorState>(),
    //"Profile": GlobalKey<NavigatorState>(),
  };

  int selectedIndex = 0;

  void selectTab(String tabItem, int index) {
    if (tabItem == currentPage) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentPage = pageKeys[index];
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await navigatorKeys[currentPage].currentState.maybePop();
          if (isFirstRouteInCurrentTab) {
            if (currentPage != "Upcoming") {
              selectTab("Upcoming", 1);

              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(children: <Widget>[
            buildOffstageNavigator("Upcoming"),
            buildOffstageNavigator("Ongoing"),
            buildOffstageNavigator("Completed"),
            //buildOffstageNavigator("Profile"),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,
                    size: 0 * SizeConfig.imageSizeMultiplier),
                label: "Upcoming",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded,
                    size: 0 * SizeConfig.imageSizeMultiplier),
                label: "Ongoing",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_activity_outlined,
                    size: 0 /*7*/ * SizeConfig.imageSizeMultiplier),
                label: "Completed",
              ),
              /*BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded,
                    size: 7 * SizeConfig.imageSizeMultiplier),
                label: "Profile",
              ),*/
            ],
            selectedLabelStyle: TextStyle(
              color: AppTheme.textColor,
              fontFamily: 'Poppins',
              fontSize: 1.8 * SizeConfig.textMultiplier,
              letterSpacing: 0.7,
              fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
                color: AppTheme.textColor,
                fontFamily: 'Poppins',
                fontSize: 1.5 * SizeConfig.textMultiplier,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w500),
            selectedItemColor: AppTheme.greenColor,
            elevation: 5.0,
            unselectedItemColor: AppTheme.iconsColor,
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            onTap: (int index) {
              selectTab(pageKeys[index], index);
            },
          ),
        ));
  }

  Widget buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

// Future<void> conLogin() async {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference busCollection =
//   FirebaseFirestore.instance
//       .collection('bus_companies');
//
//   List<String> busCom = [];
//
//   QuerySnapshot querySnapshot = await busCollection.get();
//   for (int i = 0; i < querySnapshot.docs.length; i++) {
//     busCom.insert(i, querySnapshot.docs[i]['company']);
//   }
//
//   bool flag = false;
//   for (int j = 0; j < busCom.length; j++) {
//
//     final CollectionReference adminCollection =
//     FirebaseFirestore.instance.collection(busCom[j]+'_drivers');
//     QuerySnapshot querySnapshot = await adminCollection.get();
//
//     for (int i = 0; i < querySnapshot.docs.length; i++) {
//       if (querySnapshot.docs[i]['email'] == _auth.currentUser.email) {
//         userCompany = querySnapshot
//             .docs[i]
//             .get('company');
//
//         flag = true;
//         break;
//       }
//     }
//
//     if (flag == true) {
//       break;
//     }
//   }
// }
}
