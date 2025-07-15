import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';

class NewUserOnboardingPage extends StatefulWidget {
  final String uid;
  final String phone;
  const NewUserOnboardingPage({super.key, required this.uid, required this.phone});

  @override
  State<NewUserOnboardingPage> createState() => _NewUserOnboardingPageState();
}

class _NewUserOnboardingPageState extends State<NewUserOnboardingPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Display Name")),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserCreatedInFirestore) {
            Navigator.of(context).pop(); // Or navigate to HomePage
          }
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Welcome! Please set your display name."),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Display Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      context.read<UserBloc>().add(
                        CreateUserInFirestoreEvent(
                          uid: widget.uid,
                          phone: widget.phone ?? '',
                          displayName: name,
                        ),
                      );
                    }
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
