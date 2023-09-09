import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error_handling/firestore_create_user_error.dart';
import '../../../models/user_information.dart';

abstract class UsersRemoteDataSource{
  Future<UserInformation> getUserInformation(String uid);
  Future<void> uploadUserImage(File file);
  Future<Either<FirestoreCreateUserError,bool>> addUser(UserInformation userInformation);
  Future<void> updateUser(String uid,UserInformation userInformation);
  Future<void> deleteUser(String uid);
  Future<void> getUserLoggedType(String uid);
  Future<String> getUserReference(String uid);
  Future<void> changeUserLoggedTypeByEmail(String email,String role);
  Future<void> changeUserLoggedType(String uid,String newRole);
  Future<void> initializeNewUserData(String uid);
  // Future<void> updateChildDeviceToken(String uid);
  // Future<void> updateParentDeviceToken(String uid);
  // Future<void> updateChildScore(String uid);


}