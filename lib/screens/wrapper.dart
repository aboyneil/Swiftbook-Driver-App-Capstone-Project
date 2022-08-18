import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/logins/login.dart';
import 'package:swiftbook/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftbook/navBar/page-options.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

Future<void> conLogin() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference busCollection =
      FirebaseFirestore.instance.collection('bus_companies');

  List<String> busCom = [];

  QuerySnapshot querySnapshot = await busCollection.get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    busCom.insert(i, querySnapshot.docs[i]['company']);
  }

  bool flag = false;
  for (int j = 0; j < busCom.length; j++) {
    final CollectionReference adminCollection =
        FirebaseFirestore.instance.collection(busCom[j] + '_drivers');
    QuerySnapshot querySnapshot = await adminCollection.get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i]['email'] == _auth.currentUser.email) {
        driverBusCompany = querySnapshot.docs[i].get('company');

        flag = true;
        break;
      }
    }

    if (flag == true) {
      break;
    }
  }
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //accesing the user data from the provider
    //<Users> - Users is what they are receiving from StreamProvider (main.dart)
    //so, in this file, we access the data (Users) every time we get a new value
    final user = Provider.of<Users>(context);

    //return either Home or Authenticate widget
    if (user == null) {
      return Login();
    } else {
      conLogin();

      return PageOptions();
    }
  }
}
