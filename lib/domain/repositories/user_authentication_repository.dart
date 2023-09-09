import 'package:firebase_auth/firebase_auth.dart';

import '../../data/entities/user_auth_credentials.dart';

abstract class UserAuthenticationRepository{
  Future<void> loginWithEmailAndPassword(UserAuthCredentials userLogin);
  Future<UserCredential> registerWithEmailAndPassword(UserAuthCredentials userAuthCredentials);
  Future<void> userSignOut();
}