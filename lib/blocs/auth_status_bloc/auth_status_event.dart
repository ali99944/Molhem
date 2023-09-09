
part of 'auth_status_bloc.dart';

abstract class AuthStatusEvent extends Equatable {
  const AuthStatusEvent();
}

class AuthUserActiveEvent extends AuthStatusEvent{
  const AuthUserActiveEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserNotActiveEvent extends AuthStatusEvent{
  @override
  List<Object?> get props => [];
}
//
// class SendVerificationCodeEvent extends AuthStatusEvent{
//   @override
//   List<Object?> get props => [];
// }
//
// class EmailVerifiedEvent extends AuthStatusEvent{
//   @override
//   List<Object?> get props => [];
// }