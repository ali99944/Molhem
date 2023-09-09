import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error_handling/user_register_error.dart';
import '../../core/user_case/use_case.dart';
import '../../data/entities/user_auth_credentials.dart';
import '../../data/repositories/user_authentication_repository_impl.dart';

class FirebaseRegisterUseCase implements UseCase<UserRegisterError,UserCredential>{
  final UserAuthenticationRepositoryImpl userAuthenticationRepositoryImpl;
  final UserAuthCredentials userAuthCredentials;

  FirebaseRegisterUseCase({
    required this.userAuthCredentials,
    required this.userAuthenticationRepositoryImpl
  });

  @override
  Future<Either<UserRegisterError,UserCredential>> execute() async{
    try{
      UserCredential userCredential = await userAuthenticationRepositoryImpl.registerWithEmailAndPassword(userAuthCredentials);
      return Right(userCredential);
    }on FirebaseAuthException catch(error){
      return Left(UserRegisterError(error.message!));
    }
  }
}