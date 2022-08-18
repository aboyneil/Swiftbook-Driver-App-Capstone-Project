import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/profile/userProfile.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/string_extension.dart';
import '../globals.dart';
import '../passengerList_upcoming.dart';

class UpcomingTrips extends StatefulWidget {
  const UpcomingTrips({Key key}) : super(key: key);

  @override
  _UpcomingTripsState createState() => _UpcomingTripsState();
}

class _UpcomingTripsState extends State<UpcomingTrips> {
  void showDialogs() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            '\n No passengers available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 2.0 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          elevation: 30.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.widthMultiplier),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(70.0 * SizeConfig.widthMultiplier,
                            5.0 * SizeConfig.heightMultiplier),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // conLogin();
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
                          'UPCOMING TRIPS',
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
                    .where('Travel Status', isEqualTo: 'Upcoming')
                    .where('Trip Status', isEqualTo: true)
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
                                return Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        selectedTripID =
                                        data['Trip ID'];
                                        print('Trip ID - ' + selectedTripID);
                                        print('Company - ' + '$driverBusCompany');


                                        var dbResult =
                                            await FirebaseFirestore
                                            .instance
                                            .collection(
                                            '$driverBusCompany' +
                                                '_bookingForms')
                                            .where('Trip ID',
                                            isEqualTo:
                                            selectedTripID)
                                            .get();


                                        print ('Db Result - ' + dbResult.docs.toString());
                                        if (dbResult
                                            .docs.length ==
                                            0) {
                                          showDialogs();
                                        } else {
                                          var result =
                                              await FirebaseFirestore
                                              .instance
                                              .collection(
                                              "all_trips")
                                              .doc(
                                              selectedTripID)
                                              .get();

                                          travelStatus = result
                                              .get(
                                              'Travel Status')
                                              .toString();
                                          print(travelStatus);

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) {
                                                    return PassengerListUpcoming();
                                                  }));
                                          print('full details');
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                1 * SizeConfig.heightMultiplier),
                                        width: 90 * SizeConfig.widthMultiplier,
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                3 * SizeConfig.widthMultiplier,
                                            vertical:
                                                0 * SizeConfig.heightMultiplier),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
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
                                                      color: AppTheme.greenColor,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight: FontWeight.bold,
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
                                                      SizeConfig.widthMultiplier,
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
                                                            fontFamily: 'Poppins',
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
                                                                  //data['Departure Time'] +
                                                                  "\n",
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
                                                                    0.7,
                                                              ),
                                                            ),
                                                            //bus type
                                                            TextSpan(
                                                              text: 'Bus Type: ',
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
                                                                    0.5,
                                                              ),
                                                            ),
                                                            //terminal
                                                            TextSpan(
                                                              text: 'Terminal: ',
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
                                                              text:
                                                                  data['Terminal']
                                                                      .toString(),
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
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 7 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  //book now button
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 3 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        selectedTripID =
                                                            data['Trip ID'];
                                                        print('Trip ID - ' + selectedTripID);
                                                        print('Company - ' + '$driverBusCompany');


                                                        var dbResult =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    '$driverBusCompany' +
                                                                        '_bookingForms')
                                                                .where('Trip ID',
                                                                    isEqualTo:
                                                                        selectedTripID)
                                                                .get();


                                                        print ('Db Result - ' + dbResult.docs.toString());
                                                        if (dbResult
                                                                .docs.length ==
                                                            0) {
                                                          showDialogs();
                                                        } else {
                                                          var result =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "all_trips")
                                                                  .doc(
                                                                      selectedTripID)
                                                                  .get();

                                                          travelStatus = result
                                                              .get(
                                                                  'Travel Status')
                                                              .toString();
                                                          print(travelStatus);

                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return PassengerListUpcoming();
                                                          }));
                                                          print('full details');
                                                        }
                                                      },
                                                      child: Text(
                                                        'Click to see full details...',
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 1.7 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.0,
                                                        ),
                                                      ),
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
              SizedBox(height: 5 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }
}
