class Users {
  final String uid;

  Users({this.uid});
}

class UserData {
  final String uid;
  final String email;
  final String fullName;
  final String username;
  final String company;
  final String jobAccess;

  UserData(
      {this.uid,
      this.email,
      this.fullName,
      this.username,
      this.company,
      this.jobAccess});
}
