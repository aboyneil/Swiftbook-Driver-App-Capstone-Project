import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/passengerList_completed.dart';
import 'package:swiftbook/profile/userProfile.dart';
import 'package:swiftbook/string_extension.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';

import '../globals.dart';
import '../passengerList_upcoming.dart';

class CompletedTrips extends StatefulWidget {
  const CompletedTrips({Key key}) : super(key: key);

  @override
  _CompletedTripsState createState() => _CompletedTripsState();
}

class _CompletedTripsState extends State<CompletedTrips> {
  @override
  Widget build(BuildContext context) {
    //date format
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateNowFormatted = formatter.format(now);
    print(dateNowFormatted);
    //get driver id
    String driverUid = FirebaseAuth.instance.currentUser.uid.toString();
    print('User ID: ' + driverUid);
    //print('UserCompany: ' +  userCompany);
    return Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              2 * SizeConfig.widthMultiplier,
                              6 * SizeConfig.heightMultiplier,
                              2 * SizeConfig.widthMultiplier,
                              0),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: SvgPicture.asset(
                              'assets/arrow.svg',
                              color: AppTheme.greenColor,
                              width: 0 * SizeConfig.widthMultiplier,
                            ),
                            onPressed: () {}, //do something,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'COMPLETED TRIPS',
                          textAlign: TextAlign.center,
                          style: AppTheme.pageTitleText,
                        ),
                      ),
                      //edit button
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              2 * SizeConfig.widthMultiplier,
                              0,
                              2 * SizeConfig.widthMultiplier,
                              0.2 * SizeConfig.heightMultiplier),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.account_circle_rounded,
                              color: AppTheme.greenColor,
                              size: 7.0 * SizeConfig.imageSizeMultiplier,
                            ),
                            /*icon: SvgPicture.asset(
                                'assets/edit.svg',
                                color: AppTheme.greenColor,
                                width: 6 * SizeConfig.widthMultiplier,
                              ),*/
                            onPressed: () {
                              Navigator.of(context, rootNavigator: false).push(
                                MaterialPageRoute(
                                  builder: (_) => UserProfile(),
                                ),
                              );
                              /*Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UserProfile();
                              }));*/
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('all_trips')
                    .where('Driver ID', isEqualTo: driverUid)
                    .where('Travel Status', isEqualTo: 'Completed')
                    .where('Trip Status', isEqualTo: false)
                    .where("Departure Date",
                        isGreaterThanOrEqualTo: dateNowFormatted + ' 00:00:00')
                    .orderBy('Departure Date', descending: false)
                    .orderBy('Departure Time')
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null)
                      ? new Center(child: CircularProgressIndicator())
                      : Expanded(
                          flex: 0,
                          child: SizedBox(
                            child: new ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapshot.data.docs[index];
                                DateTime selectedDateParsed =
                                    DateTime.parse(data['Departure Date']);
                                DateTime selectedTimeParsed =
                                    DateTime.parse(data['Departure Time']);
                                DateTime startTripDate =
                                    DateTime.parse(data['Start Trip DateTime']);
                                DateTime endTripDate =
                                    DateTime.parse(data['End Trip DateTime']);
                                DateTime startTripTime =
                                    DateTime.parse(data['Start Trip DateTime']);
                                DateTime endTripTime =
                                    DateTime.parse(data['End Trip DateTime']);
                                return Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        selectedTripID = data['Trip ID'];
                                        print(selectedTripID);
                                        var result = await FirebaseFirestore
                                            .instance
                                            .collection("all_trips")
                                            .doc(selectedTripID)
                                            .get();

                                        travelStatus = result
                                            .get('Travel Status')
                                            .toString();
                                        print(travelStatus);

                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return PassengerListCompleted();
                                        }));
                                        print('full details');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1 *
                                                SizeConfig.heightMultiplier),
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                5 * SizeConfig.widthMultiplier,
                                            vertical: 0 *
                                                SizeConfig.heightMultiplier),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 6,
                                              offset: Offset(0,
                                                  1.5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      top: 1 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  child: Text(
                                                    data['Company Name']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color:
                                                          AppTheme.greenColor,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      top: 1 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  child: Text(
                                                    data['Bus Class']
                                                        .toString()
                                                        .toLowerCase()
                                                        .titleCase,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontFamily: 'Poppins',
                                                        fontSize: 1.8 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  vertical: 0 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      //date
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'Date: ',
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .textColor,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 1.5 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: DateFormat(
                                                                          'MMMM d y')
                                                                      .format(
                                                                          selectedDateParsed) +
                                                                  "\n",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0.1,
                                                              ),
                                                            ),
                                                            //time
                                                            TextSpan(
                                                              text: 'Time: ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: DateFormat
                                                                          .jm()
                                                                      .format(
                                                                          selectedTimeParsed) +
                                                                  "\n",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0.7,
                                                              ),
                                                            ),
                                                            //bus type
                                                            TextSpan(
                                                              text:
                                                                  'Bus Type: ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: data['Bus Type']
                                                                      .toString() +
                                                                  '\n',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                            //terminal
                                                            TextSpan(
                                                              text:
                                                                  'Terminal: ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: data[
                                                                      'Terminal']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              //child:
                                                              Icon(
                                                                Icons
                                                                    .near_me_sharp,
                                                                color: AppTheme
                                                                    .greenColor
                                                                    .withOpacity(
                                                                        0.3),
                                                                size: 6 *
                                                                    SizeConfig
                                                                        .imageSizeMultiplier,
                                                              ),

                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: 2 *
                                                                        SizeConfig
                                                                            .widthMultiplier),
                                                                child: Text(
                                                                  data['Origin Route']
                                                                      .toUpperCase(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 2 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              //child:
                                                              Icon(
                                                                Icons
                                                                    .location_on_sharp,
                                                                color: AppTheme
                                                                    .greenColor,
                                                                size: 6 *
                                                                    SizeConfig
                                                                        .imageSizeMultiplier,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: 2 *
                                                                        SizeConfig
                                                                            .widthMultiplier),
                                                                child: Text(
                                                                  data['Destination Route']
                                                                      .toUpperCase(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
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
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            //start trip & end trip
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 8 *
                                                    SizeConfig.widthMultiplier,
                                                top: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                                right: 8 *
                                                    SizeConfig.widthMultiplier,
                                                bottom: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 100 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Trip Started: ',
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .textColor,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 1.5 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: DateFormat(
                                                                        'MMMM d y')
                                                                    .format(
                                                                        startTripDate) +
                                                                ' - ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.1,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: DateFormat
                                                                        .jm()
                                                                    .format(
                                                                        startTripTime),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      0.1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Trip Ended: ',
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .textColor,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 1.5 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: DateFormat(
                                                                        'MMMM d y')
                                                                    .format(
                                                                        endTripDate) +
                                                                ' - ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.1,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: DateFormat
                                                                        .jm()
                                                                    .format(
                                                                        endTripTime),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      0.1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                },
              ),
              SizedBox(height: 6 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }
}
