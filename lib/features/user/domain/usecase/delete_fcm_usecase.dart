import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class DeleteFCMTokenUsecase extends UseCase<void, NoParams> {
  final UserRepository repo;

  DeleteFCMTokenUsecase({required this.repo});

  @override
  FutureVoid call(NoParams params) async {
    return await repo.deleteFCMToken();
  }
}
