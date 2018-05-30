import 'package:debut_assets/models/User.dart';

class MyUser {
  static final MyUser myUser = new MyUser.Internal();

  CurrentUser get _user => myUser._user;

  set _user(CurrentUser user) {
    _user = user;
  }

  factory MyUser() {
    return myUser;
  }

  MyUser.Internal();
}
