import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/firebase/firebase_functions.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/user/data/datasource/user_datasource.dart';
import 'package:inventry_app/features/user/data/models/avatar_model.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';

class FirebaseUserDatasourceImpl extends UserDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _fireFunc = FirebaseFunctions();

  @override
  FutureEither<UserModel?> getCurrentUser() async {
    try {
      final user = _fireFunc.currentUser();
      if (user != null) {
        return right(UserModel.fromFirebaseUser(user));
      }
      return left(FirebaseError(message: 'USER NOT FOUND'));
    } on FirebaseException catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid setDisplayName(String name) async {
    try {
      final user = _fireFunc.currentUser();
      if (user != null) {
        await user.updateDisplayName(name);
        await _fireFunc.storeDisplayname(uid: user.uid, name: name);
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
  FutureEither<bool> isNewUser(String uid) async {
    try {
      final docRef = _fireFunc.getUserDoc(uid: uid);
      final docSnapshot = await docRef.get();
      return right(!docSnapshot.exists);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid createUserInFirestore({
    required String uid,
    required String phone,
    required String displayName,
  }) async {
    try {
      await _fireFunc.storeUser(
        uid: uid,
        displayName: displayName,
        phone: phone,
      );
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid claimUserHandle({
    required String uid,
    required String handle,
    required String phone,
    required String displayName,
  }) async {
    final handleDocRef = _firestore
        .collection('userHandles')
        .doc(handle.toLowerCase());
    final userDocRef = _firestore.collection('users').doc(uid);

    try {
      await _firestore.runTransaction((transaction) async {
        final handleDoc = await transaction.get(handleDocRef);

        if (handleDoc.exists) {
          throw Exception('This handle is already taken.');
        }

        // 1. Claim the handle in the 'userHandles' collection
        transaction.set(handleDocRef, {'uid': uid});

        // 2. Set the user's display name and handle
        transaction.set(userDocRef, {
          'uid': uid,
          'phone': phone,
          'displayName': displayName,
          'userHandle': handle,
        }, SetOptions(merge: true));
      });
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<UserModel?> findUserByHandle(String handle) async {
    try {
      final handleQuery =
          await _firestore
              .collection('userHandles')
              .doc(handle.toLowerCase())
              .get();

      if (!handleQuery.exists) {
        return left(FirebaseError(message: 'User with this handle not found.'));
      }

      final uid = handleQuery.data()!['uid'];
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return left(
          FirebaseError(message: 'User data could not be retrieved.'),
        );
      }

      // We need to construct a UserModel from the Firestore data
      return right(UserModel.fromFirestore(userDoc.data()!));
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<List<AvatarModel>> getAvatars() async {
    try {
      final snapshot = await _firestore.collection('avatars').orderBy('createdAt').get();
      final avatars = snapshot.docs
          .map((doc) => AvatarModel.fromMap(doc.data()))
          .toList();
      return right(avatars);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }
}
