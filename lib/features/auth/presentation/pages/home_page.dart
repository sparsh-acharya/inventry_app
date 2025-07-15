// features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/user/presentation/pages/user_profile_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as UID: $uid"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                );
              },
              child: const Text("profile"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
