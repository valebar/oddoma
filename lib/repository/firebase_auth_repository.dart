import 'package:firebase_auth/firebase_auth.dart';
import 'package:oddoma/models/user.dart';

class FirebaseAuthRepository {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthRepository({this.firebaseAuth});

  Future<User> getUser() async {
    final fUser = await firebaseAuth.currentUser();
    if (fUser == null) {
      return null;
    } else {
      return User(
        id: fUser.uid,
        email: fUser.email,
        isEmailVerified: fUser.isEmailVerified,
      );
    }
  }

  Future<bool> isAutheniticated() async {
    var user = await firebaseAuth.currentUser();
    if (user == null) {
      return false;
    } else {
      try {
        await user.reload();
      } catch (ex) {
        print(ex);
        return false;
      }
      user = await firebaseAuth.currentUser();
      return user != null;
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
