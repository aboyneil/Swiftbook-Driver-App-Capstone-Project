import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiftbook/logins/changePassLoading.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/services/auth.dart';
import 'package:swiftbook/shared/loading.dart';

import '../globals.dart';

dynamic result;

class Login extends StatefulWidget {
  final Function toggleView;

  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //to access the Function "AuthService" from auth.dart
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  bool showText = true; //show password
  bool rememberMe = false;

  void togglePasswordView() {
    setState(() {
      showText = !showText;
    });
  }

  bool showNewPassText = true;

  void toggleNewPasswordView() {
    setState(() {
      showNewPassText = !showNewPassText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Center(
              child: SafeArea(
                bottom: false,
                left: false,
                right: false,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //logo
                        Image(
                            image: AssetImage('assets/logo.png'),
                            height: 7 * SizeConfig.heightMultiplier,
                            color: AppTheme.greenColor),
                        SizedBox(
                            height:
                                0.8 * SizeConfig.heightMultiplier), //sizedbox
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'swift',
                            style: AppTheme.logoNameSwift,
                            children: [
                              TextSpan(
                                  text: 'book', style: AppTheme.logoNameBook),
                            ],
                          ),
                        ),
                        SizedBox(height: 0.7 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20 * SizeConfig.widthMultiplier),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.7 * SizeConfig.heightMultiplier),
                          child: Text(
                            'DRIVER APP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.greenColor,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 2.8 * SizeConfig.textMultiplier,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.8 * SizeConfig.heightMultiplier),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier,
                              vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: Offset(
                                    0, 1.5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 4 * SizeConfig.heightMultiplier),
                              //login text
                              Center(
                                child: Text(
                                  'Log in',
                                  style: AppTheme.containerTitleText,
                                ),
                              ),
                              SizedBox(height: 4 * SizeConfig.heightMultiplier),
                              //bus company
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('bus_companies')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CupertinoActivityIndicator(),
                                        );
                                      } else {
                                        return DropdownButtonFormField(
                                          value: driverBusCompany,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Select your company';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                5 * SizeConfig.widthMultiplier,
                                                2 * SizeConfig.heightMultiplier,
                                                2.5 *
                                                    SizeConfig.widthMultiplier,
                                                2 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 189, 56, 1.0),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red
                                                        .withOpacity(0.8)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red
                                                            .withOpacity(0.8)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                          ),
                                          isExpanded: true,
                                          isDense: true,
                                          //iconSize: 5 * SizeConfig.imageSizeMultiplier,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: AppTheme.greenColor,
                                            size: 7 *
                                                SizeConfig.imageSizeMultiplier,
                                          ),
                                          hint: Text(
                                            "Select your company",
                                            style: AppTheme.formLabelText,
                                          ),
                                          onChanged: (value) async {
                                            setState(() {
                                              driverBusCompany = value;
                                            });
                                          },
                                          items: snapshot.data.docs
                                              .map((DocumentSnapshot docs) {
                                            return new DropdownMenuItem<String>(
                                              value: docs['company'],
                                              child: new Text(
                                                docs['company'].toUpperCase(),
                                                style: AppTheme
                                                    .selectedBusDeetsText,
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    }),
                              ),
                              SizedBox(
                                  height: 3.5 * SizeConfig.heightMultiplier),
                              //email
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  //controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Please enter an email address";
                                    } else if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                  onTap: () {
                                    InputDecoration(
                                      hintText: 'Email Address',
                                      hintStyle: AppTheme.formHintText,
                                    );
                                  },
                                  style: AppTheme.formInputText,
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    labelStyle: AppTheme.formLabelText,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            5 * SizeConfig.widthMultiplier,
                                        vertical:
                                            2 * SizeConfig.heightMultiplier),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 189, 56, 1.0),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(0.8)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(0.8)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 3.3 * SizeConfig.heightMultiplier),
                              //password
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  //controller: _pass,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Please enter your password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                  onTap: () {
                                    InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: AppTheme.formHintText,
                                    );
                                  },
                                  style: AppTheme.formInputText,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: AppTheme.formLabelText,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            5 * SizeConfig.widthMultiplier,
                                        vertical:
                                            2 * SizeConfig.heightMultiplier),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 189, 56, 1.0),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(0.8)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(0.8)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    //show or hide password
                                    suffixIcon: IconButton(
                                      color: Colors.grey,
                                      onPressed: (togglePasswordView),
                                      icon: showText
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                    ),
                                  ),
                                  obscureText: showText,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                              ),
                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  8 * SizeConfig.widthMultiplier,
                                  0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      passwordDialog();
                                    },
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Poppins',
                                        fontSize:
                                            1.5 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                              //error text
                              Center(
                                child: Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontSize: 1.4 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2 * SizeConfig.heightMultiplier),
                              //login button
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              5 * SizeConfig.widthMultiplier),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          print(driverBusCompany);
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() => loading = true);
                                            final CollectionReference
                                                adminCollection =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '$driverBusCompany' +
                                                            '_drivers');

                                            QuerySnapshot querySnapshot =
                                                await adminCollection.get();

                                            for (int i = 0;
                                                i < querySnapshot.docs.length;
                                                i++) {
                                              if (querySnapshot.docs[i]
                                                      ['email'] ==
                                                  email) {
                                                result = await _auth
                                                    .signInWithEmailAndPass(
                                                        email, password);
                                                print(driverBusCompany);
                                              }
                                            }

                                            if (result == null) {
                                              setState(() {
                                                error =
                                                    'Could not sign in with those credentials';
                                                loading = false;
                                              });
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(0, 45),
                                          primary: AppTheme.greenColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: BorderSide(
                                                  color: Colors.transparent)),
                                        ),
                                        child: Text(
                                          'Log in',
                                          style: AppTheme.buttonText,
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                  height: 4.5 * SizeConfig.heightMultiplier),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.5 * SizeConfig.heightMultiplier),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void passwordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Change Password\n\n",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 2.0 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                children:[
                  TextSpan(
                    text: 'Enter a valid email address. A link will be sent to you shortly.',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 1.5 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            elevation: 30.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            actions: [
              Column(
                children: [
                  Form(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.widthMultiplier),
                        child: TextFormField(
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter an email address";
                            } else if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return "Please enter a valid email address";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              forgotPass = val;
                            });
                          },
                          onTap: () {
                            InputDecoration(
                              hintText: 'Email Address',
                              hintStyle: AppTheme.formHintText,
                            );
                          },
                          style: AppTheme.formInputText,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: AppTheme.formLabelText,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                5 * SizeConfig.widthMultiplier,
                                vertical:
                                2 * SizeConfig.heightMultiplier),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(0, 189, 56, 1.0),
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(0.8)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(0.8)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15))),
                          ),
                        ),
                      ),
                      ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.widthMultiplier,
                    ),
                    child: Row(
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
                            "Send",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                          onPressed: () async {
                            await _auth.resetPassword(forgotPass);
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder:
                                        (context) {
                                      return ChangePassLoading();
                                    }));
                          },
                        ),
                        SizedBox(width: 4 * SizeConfig.widthMultiplier),
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
                            "Cancel",
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
                  ),
                  SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                ],
              ),
            ],
          );
        });
  }
}
