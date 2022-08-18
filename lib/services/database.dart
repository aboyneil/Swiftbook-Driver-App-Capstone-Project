import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference driverCollection =
      FirebaseFirestore.instance.collection('$driverBusCompany' + '_drivers');
  final CollectionReference companyBookingCollection = FirebaseFirestore
      .instance
      .collection('$driverBusCompany' + '_bookingForms');
  final CollectionReference allBookingCollection =
      FirebaseFirestore.instance.collection('all_bookingForms');
  final CollectionReference allTripsCollection =
      FirebaseFirestore.instance.collection('all_trips');
  final CollectionReference companyTripsCollection =
      FirebaseFirestore.instance.collection('$driverBusCompany' + '_trips');

//Register users information to database
  Future updateUserdata(String email, String fullName, String username,
      String company, String jobAccess) async {
    return await driverCollection.doc(uid).set({
      'email': email,
      'fullname': fullName,
      'username': username,
      'company': company,
      'job_access': jobAccess,
    });
  }

  //Update users information to database
  Future updateUserProfile(String email, String fullName, String username,
      String company, String jobAccess) async {
    return await driverCollection.doc(uid).set({
      'email': email,
      'fullname': fullName,
      'username': username,
      'company': company,
      'job_access': jobAccess,
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      email: snapshot['email'],
      fullName: snapshot['fullname'],
      username: snapshot['username'],
      company: snapshot['company'],
      jobAccess: snapshot['job_access'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return driverCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //update "present - true" in booking forms - all
  Future updateAllPresenceStatusTrue(getUID) async {
    allBookingCollection.doc(getUID).update({
      'Present': true,
    });
  }

  //update "present - true" in booking forms - company
  Future updateCompanyPresenceStatusTrue(getUID) async {
    companyBookingCollection.doc(getUID).update({
      'Present': true,
    });
  }

  //update "present - false" in booking forms - all
  Future updateAllPresenceStatusFalse(getUID) async {
    allBookingCollection.doc(getUID).update({
      'Present': false,
    });
  }

  //update "present - true" in booking forms - company
  Future updateCompanyPresenceStatusFalse(getUID) async {
    companyBookingCollection.doc(getUID).update({
      'Present': false,
    });
  }

  //update "present - true" in booking forms - all
  Future updateAllPresentStatusTrue() async {
    allBookingCollection.doc(bookingFormsDocID).update({
      'Present': true,
    });
  }

  //update "present - true" in booking forms - company
  Future updateCompanyPresentStatusTrue() async {
    companyBookingCollection.doc(bookingFormsDocID).update({
      'Present': true,
    });
  }

  //update "present - false" in booking forms - all
  Future updateAllPresentStatusFalse() async {
    allBookingCollection.doc(bookingFormsDocID).update({
      'Present': false,
    });
  }

  //update "present - true" in booking forms - company
  Future updateCompanyPresentStatusFalse() async {
    companyBookingCollection.doc(bookingFormsDocID).update({
      'Present': false,
    });
  }

  //update company trips travel status to ongoing and start trip
  Future updateCompanyTripsTravelStatusStartTrip() async {
    companyTripsCollection.doc(selectedTripID).update({
      'Travel Status': 'Ongoing',
      'Start Trip DateTime': dateTimeNow,
      'Trip Status': true,
    });
  }

  //update all trips travel status to ongoing and start trip
  Future updateAllTripsTravelStatusStartTrip() async {
    allTripsCollection.doc(selectedTripID).update({
      'Travel Status': 'Ongoing',
      'Start Trip DateTime': dateTimeNow,
      'Trip Status': true,
    });
  }

  //update company trips travel status to completed and end trip
  Future updateCompanyTripsTravelStatusEndTrip() async {
    companyTripsCollection.doc(selectedTripID).update({
      'Travel Status': 'Completed',
      'End Trip DateTime': dateTimeNow,
      'Trip Status': false,
    });
  }

  //update all trips travel status to completed and end trip
  Future updateAllTripsTravelStatusEndTrip() async {
    allTripsCollection.doc(selectedTripID).update({
      'Travel Status': 'Completed',
      'End Trip DateTime': dateTimeNow,
      'Trip Status': false,
    });
  }

  //update all booking forms booking status to done
  Future updateAllBookingFormsBookingStatusDone() async {
    List<String> id = [];
    var result = await allBookingCollection
        .where('Trip ID', isEqualTo: selectedTripID)
        .where('Present', isEqualTo: true)
        .get();

    result.docs.forEach((element) {
      id.add(element.id);
    });
    print(id);

    for (int i = 0; i < id.length; i++) {
      allBookingCollection.doc(id[i]).update({
        'Booking Status': 'Done',
      });
    }
  }

  //update company booking forms booking status to done
  Future updateCompanyBookingFormsBookingStatusDone() async {
    List<String> id = [];
    var result = await companyBookingCollection
        .where('Trip ID', isEqualTo: selectedTripID)
        .where('Present', isEqualTo: true)
        .get();

    result.docs.forEach((element) {
      id.add(element.id);
    });
    print(id);

    for (int i = 0; i < id.length; i++) {
      companyBookingCollection.doc(id[i]).update({
        'Booking Status': 'Done',
      });
    }
  }

  //update all booking forms booking status to absent
  Future updateAllBookingFormsBookingStatusAbsent() async {
    List<String> id = [];
    var result = await allBookingCollection
        .where('Trip ID', isEqualTo: selectedTripID)
        .where('Present', isEqualTo: false)
        .get();

    result.docs.forEach((element) {
      id.add(element.id);
    });
    print(id);

    for (int i = 0; i < id.length; i++) {
      allBookingCollection.doc(id[i]).update({
        'Booking Status': 'Absent',
      });
    }
  }

  //update company booking forms booking status to absent
  Future updateCompanyBookingFormsBookingStatusAbsent() async {
    List<String> id = [];
    var result = await companyBookingCollection
        .where('Trip ID', isEqualTo: selectedTripID)
        .where('Present', isEqualTo: false)
        .get();

    result.docs.forEach((element) {
      id.add(element.id);
    });
    print(id);

    for (int i = 0; i < id.length; i++) {
      companyBookingCollection.doc(id[i]).update({
        'Booking Status': 'Absent',
      });
    }
  }
}
