import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/group/data/datasource/group_datasource.dart';
import 'package:inventry_app/features/group/data/models/group_model.dart';

class FirebaseGroupDatasourceImpl extends GroupDatasource {
  @override
  FutureVoid createGroup(String groupName, String adminId) async {
    try {
      final doc = FirebaseFirestore.instance.collection('groups').doc();
      final uid = doc.id;
      GroupModel grp = GroupModel(
        groupName: groupName,
        uid: uid,
        admin: adminId,
        members: [adminId],
        createdAt: DateTime.now(),
      );

      await doc.set(grp.toJson());
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<List<GroupModel>?> getGroups(String userId) async {
    try {
      // The new, more direct query.
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .where('members', arrayContains: userId)
              .orderBy('createdAt', descending: true)
              .get();

      // The rest of the logic remains simple and clean.
      final groups =
          querySnapshot.docs
              .map((doc) => GroupModel.fromJson(doc.data()))
              .toList();

      return right(groups);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid deleteGroup(String groupId, String adminId) async {
    try {
      final groupDoc = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId);

      await groupDoc.delete();
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid addUserToGroup({
    required String groupId,
    required String userId,
  }) async {
    final groupDocRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 1. Read the group document first within the transaction
        final groupSnapshot = await transaction.get(groupDocRef);

        if (!groupSnapshot.exists) {
          throw Exception("Group does not exist.");
        }

        // 2. Check if the user is already a member
        final members = List<String>.from(
          groupSnapshot.data()?['members'] ?? [],
        );
        if (members.contains(userId)) {
          // 3. If the user exists, throw an exception to stop the transaction
          throw Exception("User is already a member of this group.");
        }

        // 4. If the user doesn't exist, proceed with the updates
        transaction.update(groupDocRef, {
          'members': FieldValue.arrayUnion([userId]),
        });
      });
      return right(null);
    } catch (e) {
      // The error message from our check will be caught here
      return left(FirebaseError(message: e.toString()));
    }
  }
}
