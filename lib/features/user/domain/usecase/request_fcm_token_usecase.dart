import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class RequestFCMTokenUsecase extends UseCase<String?,NoParams> {
  final UserRepository repo;

  RequestFCMTokenUsecase({required this.repo});

  @override
  FutureEither<String?> call(NoParams params) async {
    return await repo.requestFCMToken();
  }
}
