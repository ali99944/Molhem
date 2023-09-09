

import 'dart:async';

import 'package:Molhem/data/datasource/remote/users_data/firestore_users_remote_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/user_information.dart';

part 'auth_status_event.dart';
part 'auth_status_state.dart';

class AuthStatusBloc extends Bloc<AuthStatusEvent, AuthStatusState> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserInformation? userInformation;
  String? uid;
  String? id;

  AuthStatusBloc() : super(AuthStatusInitial()){
    Future.delayed(const Duration(seconds: 9)).whenComplete((){
      firebaseAuth.authStateChanges().listen((user) async{
        if(user != null){
          uid = user.uid;

          add(AuthUserActiveEvent());
        }else{
          add(AuthUserNotActiveEvent());
          uid = null;
        }
      });
    });

    on<AuthStatusEvent>((event, emit) async{
      if(event is AuthUserActiveEvent){
        FirestoreUsersRemoteDataSource firestoreUsersRemoteDataSource = FirestoreUsersRemoteDataSource();
        userInformation = await firestoreUsersRemoteDataSource.getUserInformation(uid!);
        id = await firestoreUsersRemoteDataSource.getUserReference(uid!);
        String? loggedAs = await firestoreUsersRemoteDataSource.getUserLoggedType(uid!);

        return emit(UserLoggedInState(loggedAs: loggedAs));
      }else if(event is AuthUserNotActiveEvent){
        emit(UserNotLoggedInState());
      }
    });
  }
}