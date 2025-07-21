import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/firebase/firebase_functions.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/user/data/datasource/user_datasource.dart';
import 'package:inventry_app/features/user/data/models/avatar_model.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';

class FirebaseUserDatasourceImpl implements UserDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _fireFunc = FirebaseFunctions();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  FutureEither<UserModel?> getCurrentUser() async {
    try {
      final user = await _fireFunc.currentUser();
      if (user != null) {
        return Right(user);
      }
      return Left(FirebaseError(message: 'USER NOT FOUND'));
    } on FirebaseException catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<String?> requestFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return Right(token);
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid saveFCMToken(String token) async {
    try {
      final user = await _fireFunc.currentUser();
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
        return const Right(null);
      }
      return Left(FirebaseError(message: "No user is signed in."));
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid setDisplayName(String name) async {
    try {
      final updated = await _fireFunc.storeDisplayname(name: name);
      return updated
          ? Right(null)
          : Left(FirebaseError(message: "No user is signed in."));
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> isNewUser(String uid) async {
    try {
      final docRef = _fireFunc.getUserDoc(uid: uid);
      final docSnapshot = await docRef.get();
      return Right(!docSnapshot.exists);
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid createUserInFirestore({
    required String uid,
    required String phone,
    required String displayName,
    String? avatarUrl,
  }) async {
    try {
      await _fireFunc.storeUser(
        uid: uid,
        displayName: displayName,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid claimUserHandle({
    required String uid,
    required String handle,
    required String phone,
    required String displayName,
    String? avatarUrl,
  }) async {
    final handleDocRef =
        _firestore.collection('userHandles').doc(handle.toLowerCase());
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
        transaction.set(
            userDocRef,
            {
              'uid': uid,
              'phone': phone,
              'displayName': displayName,
              'userHandle': handle,
              if (avatarUrl != null) 'avatarUrl': avatarUrl,
            },
            SetOptions(merge: true));
      });
      return const Right(null);
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<UserModel?> findUserByHandle(String handle) async {
    try {
      final handleQuery = await _firestore
          .collection('userHandles')
          .doc(handle.toLowerCase())
          .get();

      if (!handleQuery.exists) {
        return Left(FirebaseError(message: 'User with this handle not found.'));
      }

      final uid = handleQuery.data()!['uid'];
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return Left(
          FirebaseError(message: 'User data could not be retrieved.'),
        );
      }

      // We need to construct a UserModel from the Firestore data
      return Right(UserModel.fromFirestore(userDoc.data()!));
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<List<AvatarModel>> getAvatars() async {
    try {
      final snapshot = await _firestore.collection('avatars').get();
      final avatars =
          snapshot.docs.map((doc) => AvatarModel.fromMap(doc.data())).toList();
      return Right(avatars);
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }
}
