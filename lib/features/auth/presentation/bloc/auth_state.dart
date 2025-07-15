part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class OtpSentState extends AuthState {
  final String verificationId;
  final String? errorMessage;
  const OtpSentState(this.verificationId, {this.errorMessage});

  @override
  List<Object> get props => [verificationId, errorMessage ?? ''];
}

class AuthenticatedState extends AuthState {
  final UserEntity user;
  const AuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}
