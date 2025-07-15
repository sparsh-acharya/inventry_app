import 'package:get_it/get_it.dart';
import 'package:inventry_app/injector/modules/auth_module.dart';
import 'package:inventry_app/injector/modules/user_module.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initAuthModule();
  await initUserModule();
}
