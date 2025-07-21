import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class SaveFCMTokenUsecase extends UseCase<void, String> {
  final UserRepository repo;

  SaveFCMTokenUsecase({required this.repo});

  @override
  FutureEither<void> call(String params) async {
    return await repo.saveFCMToken(params);
  }
}
