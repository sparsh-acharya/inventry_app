import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class ClaimHandleParams {
  final String uid;
  final String handle;
  final String displayName;
  final String phone;

  ClaimHandleParams({
    required this.uid,
    required this.handle,
    required this.phone,
    required this.displayName,
  });
}

class ClaimHandleUsecase extends UseCase<void, ClaimHandleParams> {
  final UserRepository repo;

  ClaimHandleUsecase({required this.repo});

  @override
  FutureVoid call(ClaimHandleParams params) {
    return repo.claimUserHandle(
      uid: params.uid,
      handle: params.handle,
      displayName: params.displayName,
      phone: params.phone,
    );
  }
}
