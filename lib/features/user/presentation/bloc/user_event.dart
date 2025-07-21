part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class UpdateDisplayNameEvent extends UserEvent {
  final String newName;

  const UpdateDisplayNameEvent(this.newName);

  @override
  List<Object?> get props => [newName];
}

class IsNewUserEvent extends UserEvent {
  final String uid;

  const IsNewUserEvent({required this.uid});

  @override
  List<Object?> get props => [uid];

}

class CreateUserInFirestoreEvent extends UserEvent {
  final String uid;
  final String displayName;
  final String phone;
  final String userHandle;
  final String? avatarUrl;

  const CreateUserInFirestoreEvent({required this.uid, required this.displayName,required  this.phone,required this.userHandle, this.avatarUrl});

  @override
  List<Object?> get props => [uid, displayName,phone,userHandle, avatarUrl];
}

class FetchAvatarsEvent extends UserEvent {}

class RequestFCMTokenEvent extends UserEvent {}

class SaveFCMTokenEvent extends UserEvent {
  final String token;

  const SaveFCMTokenEvent(this.token);

  @override
  List<Object?> get props => [token];
}

