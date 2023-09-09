import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/error_handling/user_login_error.dart';
import '../../data/datasource/remote/users_data/firestore_users_remote_data_source.dart';
import '../../data/entities/user_auth_credentials.dart';
import '../../data/repositories/user_authentication_repository_impl.dart';
import '../../domain/usecase/firebase_login_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserAuthenticationRepositoryImpl firebaseLoginRepositoryImpl =
  UserAuthenticationRepositoryImpl();
  final FirestoreUsersRemoteDataSource firestoreUsersRemoteDataSource =
  FirestoreUsersRemoteDataSource();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        emit(LoginLoading());
        final FirebaseLoginUseCase firebaseLoginUseCase = FirebaseLoginUseCase(
          firebaseLoginRepositoryImpl: firebaseLoginRepositoryImpl,
          userAuthCredentials: event.userAuthCredentials,
        );
        await firestoreUsersRemoteDataSource.changeUserLoggedTypeByEmail(
          event.userAuthCredentials.email,
          event.role,
        );
        Either<UserLoginError, UserCredential> response =
        await firebaseLoginUseCase.execute();
        String? deviceToken = await FirebaseMessaging.instance.getToken();

        response.fold(
              (userLoginError) {
            emit(LoginFailure(message: userLoginError.message));
          },
              (credentials) async {
            QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').get();
            List<QueryDocumentSnapshot> docs =
            snapshot.docs.where((element) => element['uid'] == credentials.user!.uid).toList();
            QueryDocumentSnapshot user = docs.first;
            if (event.role == 'child') {
              await FirebaseFirestore.instance.collection('users').doc(user.id).update({
                'childToken': deviceToken,
                'lastChildLoginTime': DateTime.now().millisecondsSinceEpoch,
              });
            } else {
              await FirebaseFirestore.instance.collection('users').doc(user.id).update({
                'parentToken': deviceToken,
              });
            }
          },
        );

        if(response.isRight()){
          return emit(LoginSuccess());
        }
      } else if (event is ResetLoginInitial) {
        return emit(LoginInitial());
      }
    });
  }
}