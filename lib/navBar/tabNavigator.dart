import 'package:flutter/material.dart';
import 'package:swiftbook/trips/ongoingTrips.dart';
import 'package:swiftbook/trips/completedTrips.dart';
import 'package:swiftbook/trips/upcomingTrips.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "Upcoming") {
      child = UpcomingTrips();
    } else if (tabItem == "Ongoing") {
      child = OngoingTrips();
    }
    else if (tabItem == "Completed") {
      child = CompletedTrips();
    }

      return Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => child);
        },
      );
    }
  }
