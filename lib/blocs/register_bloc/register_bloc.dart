import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../core/error_handling/firestore_create_user_error.dart';
import '../../core/error_handling/user_register_error.dart';
import '../../data/datasource/remote/users_data/firestore_users_remote_data_source.dart';
import '../../data/entities/user_auth_credentials.dart';
import '../../data/models/user_information.dart';
import '../../data/repositories/user_authentication_repository_impl.dart';
import '../../domain/usecase/firebase_register_case.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async{
      if(event is RegisterButtonPressed){
        emit(RegisterLoading());

        FirestoreUsersRemoteDataSource firestoreUsersRemoteDataSource = FirestoreUsersRemoteDataSource();
        UserAuthenticationRepositoryImpl userAuthenticationRepositoryImpl = UserAuthenticationRepositoryImpl();
        FirebaseRegisterUseCase firebaseRegisterUseCase = FirebaseRegisterUseCase(
            userAuthCredentials: event.userAuthCredentials,
            userAuthenticationRepositoryImpl: userAuthenticationRepositoryImpl
        );

        try{
          UserInformation userInformation = event.userInformation;

          await firebaseRegisterUseCase.execute().then((Either<UserRegisterError,UserCredential> result) {
            result.fold(
                    (l) => throw l.message,
                    (r) => userInformation.uid = r.user?.uid ?? ''
            );
          });

          emit(GettingEverythingReady());

          String? deviceToken = await FirebaseMessaging.instance.getToken();
          userInformation.childToken = deviceToken;
          userInformation.parentToken = deviceToken;

          await firestoreUsersRemoteDataSource.addUser(userInformation).then((Either<FirestoreCreateUserError,bool> result){
            result.fold(
                    (l) => throw l.message,
                    (r){}
            );
          });

          try{
            await firestoreUsersRemoteDataSource.initializeNewUserData(userInformation.uid!).then((value){
              return emit(RegisterSuccess());
            });
          }catch(error){

          }
        } catch(error){
          emit(RegisterFailure(message: error.toString  ()));
        }
      }else if(event is ResetRegisterInitial){
        emit(RegisterInitial());
      }
    });
  }
}