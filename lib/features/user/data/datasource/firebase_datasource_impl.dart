import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/features/user/data/datasource/user_datasource.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';

class FirebaseUserDatasourceImpl extends UserDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return right(UserModel.fromFirebaseUser(user));
      }
      return left(FirebaseError(message: 'USER NOT FOUND'));
    } on FirebaseException catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDisplayName(String name) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        return right(null);
      } else {
        return left(FirebaseError(message: "No user is signed in."));
      }
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isNewUser(String uid) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnapshot = await docRef.get();
      return right(docSnapshot.exists);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createUserInFirestore({required String uid,required String phone, required String displayName}) async {
    try {
      await _store.collection('users').doc(uid).set({'displayName': displayName,'phone': phone}, SetOptions(merge: true));
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }
}
