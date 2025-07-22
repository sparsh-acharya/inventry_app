import 'package:inventry_app/core/utils/typedef.dart';

abstract class UseCase<Type, Params> {
  FutureEither<Type> call(Params params);
}

class NoParams {
  const NoParams();
}

class SendOTPParams {
  final String phone;
  final Function(String verificationId) onCodeSent;
  final Function(String uid)? onAutoVerified;

  SendOTPParams({
    required this.phone,
    required this.onCodeSent,
    this.onAutoVerified,
  });
}

class VerifyOTPParams {
  final String verificationId;
  final String otp;

  VerifyOTPParams({required this.verificationId, required this.otp});
}

class CreateGroupParams {
  final String groupName;
  final String adminId;

  CreateGroupParams({required this.groupName, required this.adminId});
}

class DeleteGroupParams {
  final String groupId;
  final String adminId;

  DeleteGroupParams({required this.groupId, required this.adminId});
}

class AddItemParams {
  final String itemName;
  final int count;
  final String unit;
  final String groupId;
  final bool automationEnabled;
  final int? consumptionRate;
  final DateTime? automationStartDate;

  AddItemParams({
    required this.itemName,
    required this.count,
    required this.unit,
    required this.groupId,
    this.automationEnabled = false,
    this.consumptionRate,
    this.automationStartDate,
  });
}

class DeleteItemParams {
  final String groupId;
  final String itemId;

  DeleteItemParams({required this.groupId, required this.itemId});
}

class EditItemParams {
  final String groupId;
  final String itemId;
  final String itemName;
  final int count;
  final String unit;

  EditItemParams({
    required this.groupId,
    required this.itemId,
    required this.itemName,
    required this.count,
    required this.unit,
  });
}

class AddUserToGroupParams {
  final String groupId;
  final String userId;

  AddUserToGroupParams({required this.groupId, required this.userId});
}
