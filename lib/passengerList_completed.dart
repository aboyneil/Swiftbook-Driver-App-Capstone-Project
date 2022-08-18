import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swiftbook/string_extension.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';

import 'globals.dart';

class PassengerListCompleted extends StatefulWidget {
  const PassengerListCompleted({Key key}) : super(key: key);

  @override
  _PassengerListCompletedState createState() => _PassengerListCompletedState();
}

class _PassengerListCompletedState extends State<PassengerListCompleted> {
  String discountID;
  String ticketID;
  String priceCategory;
  String seatNumber;


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
                        //edit button
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
                                Icons.account_circle_rounded,
                                color: AppTheme.greenColor,
                                size: 0 * SizeConfig.imageSizeMultiplier,
                              ),
                              onPressed: () {},
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
                      .where('Booking Status', isNotEqualTo: 'Active')
                      .orderBy('Booking Status', descending: true)
                      .orderBy('Present', descending: false)
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
                              separatorBuilder: (context, index) => SizedBox(height: 2 * SizeConfig.heightMultiplier),
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
                                    GestureDetector(
                                      onTap: (){
                                        discountID = data['ID'];
                                        ticketID = data['Ticket ID'];
                                        priceCategory =
                                        data['Passenger Category'];
                                        seatNumber = data['Seat Number'];
                                        print(bookingFormsDocID);
                                        displayShowDialog();
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
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: Offset(0, 1.5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0 *
                                                        SizeConfig.widthMultiplier,
                                                    1.0 *
                                                        SizeConfig.heightMultiplier,
                                                    7.0 *
                                                        SizeConfig.widthMultiplier,
                                                    1.0 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                child: Icon(
                                                  data['Present'] == true
                                                      ? Icons.check_circle_outline_rounded
                                                      : Icons.cancel_outlined,
                                                  color: AppTheme.greenColor,
                                                  size: 7.5 * SizeConfig.imageSizeMultiplier,
                                                )
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                discountID = data['ID'];
                                                ticketID = data['Ticket ID'];
                                                priceCategory =
                                                data['Passenger Category'];
                                                seatNumber = data['Seat Number'];
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
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                ),
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
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
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
}
