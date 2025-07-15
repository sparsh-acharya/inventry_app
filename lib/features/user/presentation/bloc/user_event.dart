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

  const CreateUserInFirestoreEvent({required this.uid, required this.displayName,required  this.phone});

  @override
  List<Object?> get props => [uid, displayName,phone];
}
