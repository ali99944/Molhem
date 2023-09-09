import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/user_authentication_repository.dart';
import '../entities/user_auth_credentials.dart';

class UserAuthenticationRepositoryImpl implements UserAuthenticationRepository{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential?> loginWithEmailAndPassword(UserAuthCredentials user) async {
    try{
      return await firebaseAuth.signInWithEmailAndPassword(email: user.email, password: user.password);
    } on FirebaseAuthException catch(loginError){
      rethrow;
    }
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword(UserAuthCredentials userAuthCredentials) async{
    try{
      return await firebaseAuth.createUserWithEmailAndPassword(
          email: userAuthCredentials.email,
          password: userAuthCredentials.password
      );
    }on FirebaseAuthException catch(registerError){
      rethrow;
    }
  }

  @override
  Future<void> userSignOut() {
    // TODO: implement userSignOut
    throw UnimplementedError();
  }
}