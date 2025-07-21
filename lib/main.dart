import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inventry_app/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:inventry_app/features/group/presentation/bloc/group_bloc.dart';
import 'package:inventry_app/features/list/presentation/bloc/list_bloc.dart';
import 'package:inventry_app/features/user/presentation/bloc/user_bloc.dart';

import 'firebase_options.dart';
import 'injector/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(GetCurrentUserEvent()),
        ),
        BlocProvider<UserBloc>(create: (_) => di.sl<UserBloc>()),
        BlocProvider<GroupBloc>(create: (_) => di.sl<GroupBloc>()),
        BlocProvider<ListBloc>(create: (_) => di.sl<ListBloc>()),
      ],
      child: MaterialApp(
        title: 'Inventory App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
