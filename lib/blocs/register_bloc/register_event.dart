part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent{
  final UserInformation userInformation;
  final UserAuthCredentials userAuthCredentials;
  const RegisterButtonPressed({required this.userInformation,required this.userAuthCredentials});

  @override
  List<Object?> get props => [userInformation,userAuthCredentials];
}

class ResetRegisterInitial extends RegisterEvent{
  @override
  List<Object?> get props => [];
}