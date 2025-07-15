import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/user/presentation/bloc/user_bloc.dart';



class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            _nameController.text = state.user.displayName ?? '';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("User ID", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(state.user.uid, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 24),

                  const Text("Display Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter display name",
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final newName = _nameController.text.trim();
                      if (newName.isNotEmpty) {
                        context.read<UserBloc>().add(UpdateDisplayNameEvent(newName));
                      }
                    },
                    child: const Text("Update Display Name"),
                  ),
                ],
              ),
            );
          }

          if (state is UserError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
