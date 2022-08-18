import 'package:flutter/material.dart';
import 'package:swiftbook/navBar/page-options.dart';
import 'package:swiftbook/passengerList_upcoming.dart';
import 'package:swiftbook/profile/userProfile.dart';
import 'package:swiftbook/screens/wrapper.dart';
import 'package:swiftbook/services/auth.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:swiftbook/models/user.dart';

//void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return StreamProvider<Users>.value(
              value: AuthService().user,
              initialData: null,
              child: MaterialApp(
                title: 'SwiftBook',
                theme: AppTheme.lightTheme,
                home: Wrapper(),
                routes: <String, WidgetBuilder>{
                  '/login': (BuildContext context) => new PageOptions(),
                  '/pageOptions': (BuildContext context) => new PageOptions(),
                  '/userProfile': (BuildContext context) => new UserProfile(),
                  '/passengerListUpcoming': (BuildContext context) =>
                      new PassengerListUpcoming(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
