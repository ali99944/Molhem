part of 'login_bloc.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent{
  final UserAuthCredentials userAuthCredentials;
  final String role;
  const LoginButtonPressed({required this.userAuthCredentials, required this.role});

  @override
  List<Object?> get props => [userAuthCredentials];
}

class ResetLoginInitial extends LoginEvent{
  @override
  List<Object?> get props => [];
}