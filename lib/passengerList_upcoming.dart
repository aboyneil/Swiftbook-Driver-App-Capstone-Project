import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/string_extension.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'globals.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

final DatabaseService db = DatabaseService();

class PassengerListUpcoming extends StatefulWidget {
  const PassengerListUpcoming({Key key}) : super(key: key);

  @override
  _PassengerListUpcomingState createState() => _PassengerListUpcomingState();
}

class _PassengerListUpcomingState extends State<PassengerListUpcoming> {
  String discountID;
  String ticketID;
  String priceCategory;
  String seatNumber;

  void showDialogs() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            '\nInvalid QR Code',
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
    print(travelStatus);
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        1 * SizeConfig.widthMultiplier,
                        4 * SizeConfig.heightMultiplier,
                        1 * SizeConfig.widthMultiplier,
                        3 * SizeConfig.heightMultiplier),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                2.5 * SizeConfig.widthMultiplier,
                                0 * SizeConfig.heightMultiplier,
                                2 * SizeConfig.widthMultiplier,
                                0),
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
                          child: Text(
                            'LIST OF PASSENGERS',
                            textAlign: TextAlign.center,
                            style: AppTheme.pageTitleText,
                          ),
                        ),
                        //qr scanner button
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0 * SizeConfig.widthMultiplier,
                                0,
                                2.5 * SizeConfig.widthMultiplier,
                                0 * SizeConfig.heightMultiplier),
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.qr_code_scanner,
                                color: AppTheme.greenColor,
                                size: 7 * SizeConfig.imageSizeMultiplier,
                              ),
                              onPressed: () async {
                                ScanResult qrResult =
                                    await BarcodeScanner.scan();
                                String getTicketID = qrResult.rawContent;
                                String docTemp;
                                var result = await FirebaseFirestore.instance
                                    .collection('all_bookingForms')
                                    .where('Ticket ID', isEqualTo: getTicketID)
                                    .where('Trip ID', isEqualTo: selectedTripID)
                                    .get();
                                if (result.docs.length == 0) {
                                  showDialogs();
                                } else {
                                  result.docs.forEach((val) {
                                    docTemp = val.id;
                                  });
                                  db.updateAllPresenceStatusTrue(docTemp);
                                  db.updateCompanyPresenceStatusTrue(docTemp);

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                    return PassengerListUpcoming();
                                  }));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                //color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('all_bookingForms')
                      .where('Trip ID', isEqualTo: selectedTripID)
                      .where('Booking Status', isEqualTo: 'Active')
                      .orderBy('Seat Number', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.data == null)
                        ? new Center(child: CircularProgressIndicator())
                        : new Column(
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  //height: 100,
                                  child: new ListView.separated(
                                    separatorBuilder: (context, index) => SizedBox(
                                        height: 2 *
                                            SizeConfig.heightMultiplier),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot data =
                                          snapshot.data.docs[index];
                                      isPresent = data['Present'];
                                      print(
                                          isPresent.toString() + ' ' + data.id);
                                      //print(isPresent);
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            width:
                                                90 * SizeConfig.widthMultiplier,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 3 *
                                                    SizeConfig.widthMultiplier,
                                                vertical: 0 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0,
                                                      1.5), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2.0 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      1.0 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      5.0 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      1.0 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  child: Transform.scale(
                                                    scale: 1.25,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Switch(
                                                      value: isPresent,
                                                      activeColor: isPresent ==
                                                              true
                                                          ? AppTheme.greenColor
                                                          : Colors.grey[500],
                                                      activeTrackColor:
                                                          isPresent == true
                                                              ? Color.fromRGBO(
                                                                  24,
                                                                  168,
                                                                  30,
                                                                  0.3)
                                                              : Colors
                                                                  .grey[350],
                                                      inactiveThumbColor:
                                                          isPresent == true
                                                              ? AppTheme
                                                                  .greenColor
                                                              : Colors
                                                                  .grey[500],
                                                      inactiveTrackColor:
                                                          isPresent == true
                                                              ? Color.fromRGBO(
                                                                  24,
                                                                  168,
                                                                  30,
                                                                  0.3)
                                                              : Colors
                                                                  .grey[350],
                                                      onChanged: (bool value) {
                                                        isPresent = value;
                                                        print(isPresent
                                                                .toString() +
                                                            ' ' +
                                                            data.id);
                                                        if (isPresent == true) {
                                                          bookingFormsDocID =
                                                              data.id;
                                                          presentTrueDialog();
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    discountID = data['ID'];
                                                    ticketID =
                                                        data['Ticket ID'];
                                                    priceCategory = data[
                                                        'Passenger Category'];
                                                    seatNumber =
                                                        data['Seat Number'];
                                                    print(bookingFormsDocID);
                                                    displayShowDialog();
                                                  },
                                                  child: Text(
                                                    data['First Name']
                                                            .toString().toLowerCase()
                                                            .titleCase +
                                                        ' ' +
                                                        data['Last Name']
                                                            .toString().toLowerCase()
                                                            .titleCase,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20 * SizeConfig.widthMultiplier),
                child: ElevatedButton(
                  onPressed: () async {
                    startTripDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0, 45),
                    primary: AppTheme.greenColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.transparent)),
                  ),
                  child: Text(
                    'Start Trip',
                    style: AppTheme.buttonText,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayShowDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 30.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                Text(
                  "Passenger Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.greenColor,
                    fontFamily: 'Poppins',
                    fontSize: 2.0 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.widthMultiplier),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2 * SizeConfig.widthMultiplier,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "Ticket ID\n",
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontFamily: 'Poppins',
                        fontSize: 1.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ticketID + '\n' + '\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 1.9 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "Price Category\n",
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontFamily: 'Poppins',
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: priceCategory + '\n' + '\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 1.9 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "Discount ID\n",
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontFamily: 'Poppins',
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: discountID.titleCase + '\n\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 1.9 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "Seat Number\n",
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontFamily: 'Poppins',
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: seatNumber.toString() + '\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 1.9 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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

  void startTripDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox (height: 2 * SizeConfig.heightMultiplier),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Are you sure you want to start the trip?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 2.0 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
            elevation: 30.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
                              5.0 * SizeConfig.heightMultiplier),
                          primary: AppTheme.greenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: AppTheme.greenColor)),
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                        ),
                        onPressed: () {
                          db.updateAllTripsTravelStatusStartTrip();
                          db.updateCompanyTripsTravelStatusStartTrip();

                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/pageOptions', (Route<dynamic> route) => false);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
                              5.0 * SizeConfig.heightMultiplier),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: AppTheme.greenColor)),
                        ),
                        child: Text(
                          "No",
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
                  SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                ],
              ),
            ],
          );
        });
  }

  void presentTrueDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox (height: 2 * SizeConfig.heightMultiplier),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Are you sure?",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 2.0 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
            elevation: 30.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
                              5.0 * SizeConfig.heightMultiplier),
                          primary: AppTheme.greenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: AppTheme.greenColor)),
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          db.updateAllPresentStatusTrue();
                          db.updateCompanyPresentStatusTrue();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
                              5.0 * SizeConfig.heightMultiplier),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: AppTheme.greenColor)),
                        ),
                        child: Text(
                          "No",
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
                  SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                ],
              ),
            ],
          );
        });
  }
}
