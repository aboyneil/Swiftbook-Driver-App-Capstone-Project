import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/services/auth.dart';
import 'package:swiftbook/string_extension.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/shared/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _auth = AuthService();
  bool loading = false;

  String email = '';
  String fullName = '';
  String username = '';
  String company = '';
  String jobAccess = '';

  //get user data
  void getUserData() async {
    User user = FirebaseAuth.instance.currentUser;
    var userInfo = await FirebaseFirestore.instance
        .collection('$driverBusCompany' + '_drivers')
        .doc(user.uid)
        .get();
    setState(() {
      email = userInfo['email'];
      fullName = userInfo['fullname'];
      username = userInfo['username'];
      company = userInfo['company'];
      jobAccess = userInfo['job_access'];
    });
  }

  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String strJobAccess = jobAccess.toLowerCase();

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: AppTheme.bgColor,
            body: SafeArea(
              bottom: false,
              left: false,
              right: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 30 * SizeConfig.heightMultiplier,
                          decoration: BoxDecoration(
                            color: AppTheme.bgColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    3 * SizeConfig.widthMultiplier,
                                    3 * SizeConfig.heightMultiplier,
                                    2 * SizeConfig.widthMultiplier,
                                    1.2 * SizeConfig.heightMultiplier),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: SvgPicture.asset(
                                    'assets/arrow.svg',
                                    color: AppTheme.greenColor,
                                    width: 5 * SizeConfig.widthMultiplier,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, //do something,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0 * SizeConfig.widthMultiplier,
                                    3 * SizeConfig.heightMultiplier,
                                    0 * SizeConfig.widthMultiplier,
                                    1.2 * SizeConfig.heightMultiplier),
                                child: Text(
                                  'PROFILE',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.pageTitleText,
                                ),
                              ),
                            ),
                            //edit button
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    2 * SizeConfig.widthMultiplier,
                                    3 * SizeConfig.heightMultiplier,
                                    3 * SizeConfig.widthMultiplier,
                                    2 * SizeConfig.heightMultiplier),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: SvgPicture.asset(
                                    'assets/edit.svg',
                                    color: AppTheme.greenColor,
                                    width: 0 * SizeConfig.widthMultiplier,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                    height: 13 * SizeConfig.heightMultiplier),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        top: 8 * SizeConfig.heightMultiplier,
                                        right: 4.5 * SizeConfig.widthMultiplier,
                                        left: 4.5 * SizeConfig.widthMultiplier,
                                      ),
                                      width: 100 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                            offset: Offset(0,
                                                1.5), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                              height: 11.5 *
                                                  SizeConfig.heightMultiplier),
                                          //full name
                                          Text(
                                            fullName.titleCase,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          //username
                                          Text(
                                            '@' + username,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          //divider
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12 *
                                                  SizeConfig.widthMultiplier,
                                              vertical: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          //email
                                          Text(
                                            'Email Address',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppTheme.logoGrey,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.3 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.7 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          //email value
                                          SizedBox(
                                            width: 70 * SizeConfig.widthMultiplier,
                                            child: Text(
                                              email,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color:
                                                    Colors.black.withOpacity(0.7),
                                                fontFamily: 'Poppins',
                                                fontSize:
                                                    2 * SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                          //divider
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12 *
                                                  SizeConfig.widthMultiplier,
                                              vertical: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          //company
                                          Text(
                                            'Company',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppTheme.logoGrey,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.3 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.7 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          //company value
                                          Text(
                                            company.titleCase,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontFamily: 'Poppins',
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          //divider
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12 *
                                                  SizeConfig.widthMultiplier,
                                              vertical: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          //job access
                                          Text(
                                            'Job Access',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppTheme.logoGrey,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.3 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.7 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          //job access value
                                          Text(
                                            strJobAccess.titleCase,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontFamily: 'Poppins',
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          SizedBox(
                                              height: 3 * SizeConfig.heightMultiplier),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: SizedBox(
                                        child: CircleAvatar(
                                          radius: 17 *
                                              SizeConfig.imageSizeMultiplier,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                            ),
                                            radius: 16 *
                                                SizeConfig.imageSizeMultiplier,
                                            backgroundImage:
                                                AssetImage('assets/user.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5 * SizeConfig.heightMultiplier),
                    //logout button
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15 * SizeConfig.widthMultiplier),
                            child: ElevatedButton(
                              onPressed: () async {
                                driverBusCompany = null;
                                _auth.signOut();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(0, 45),
                                primary: AppTheme.greenColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side:
                                        BorderSide(color: Colors.transparent)),
                              ),
                              child: Text(
                                'Log Out',
                                style: AppTheme.buttonText,
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          );
  }
}
