part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserState {
  final String message;

  const UserUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class NewUserState extends UserState{
  final String uid;

  const NewUserState({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserCreatedInFirestore extends UserState {
  final String message;

  const UserCreatedInFirestore(this.message);

  @override
  List<Object?> get props => [message];
}

class AvatarsLoading extends UserState {}

class AvatarsLoaded extends UserState {
  final List<AvatarEntity> avatars;
  const AvatarsLoaded({required this.avatars});
  @override
  List<Object?> get props => [avatars];
}
