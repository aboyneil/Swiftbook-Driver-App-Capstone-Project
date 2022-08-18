import 'package:flutter/material.dart';
import 'package:swiftbook/shared/loading.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';

class ChangePassLoading extends StatefulWidget {
  const ChangePassLoading({Key key}) : super(key: key);

  @override
  _ChangePassLoadingState createState() => _ChangePassLoadingState();
}

class _ChangePassLoadingState extends State<ChangePassLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 6 * SizeConfig.widthMultiplier,
                      vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset:
                        Offset(0, 1.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 4 * SizeConfig.heightMultiplier),
                      //login text
                      Center(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5 * SizeConfig.heightMultiplier),
                      Loading(),
                      SizedBox(height: 5 * SizeConfig.heightMultiplier),
                      Center(
                        child: SizedBox(
                          width: 60.0 * SizeConfig.widthMultiplier,
                          child: Text(
                            'Kindly click the link sent on your email address to change your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.heightMultiplier),
                    ],
                  ),
                ),
                SizedBox(height: 5 * SizeConfig.heightMultiplier),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25 * SizeConfig.widthMultiplier),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                            'Go Back',
                            style: AppTheme.buttonText,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
