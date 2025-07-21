// lib/features/user/presentation/pages/new_user_onboarding_page.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventry_app/features/user/domain/entity/avatar_entity.dart';
import '../bloc/user_bloc.dart';

class NewUserOnboardingPage extends StatefulWidget {
  final String uid;
  final String phone;
  const NewUserOnboardingPage({
    super.key,
    required this.uid,
    required this.phone,
  });

  @override
  State<NewUserOnboardingPage> createState() => _NewUserOnboardingPageState();
}

class _NewUserOnboardingPageState extends State<NewUserOnboardingPage> {
  final _nameController = TextEditingController();
  final _handleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late PageController _pageController;
  final int _initialPage = 120;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.6, // Show adjacent items
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
        automaticallyImplyLeading: false, // Prevent going back
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AvatarsLoading) {
            return (Center(child: Text('avatar is loading')));
          }
          if (state is AvatarsLoaded) {
            final isLoading = state is UserLoading;

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    state.avatars.isEmpty
                        ? const CircularProgressIndicator(color: Colors.green)
                        : SizedBox(
                          height: 200,
                          child: PageView.builder(
                            itemCount: 10000, // Large number for looping
                            physics: const ClampingScrollPhysics(),
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              final avatarIndex = index % state.avatars.length;
                              return avatarView(
                                index,
                                state.avatars[avatarIndex].url,
                              );
                            },
                          ),
                        ),
                    const SizedBox(height: 24),
                    const Text(
                      "Welcome to InventryApp!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Please set your display name to get started.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Display Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your display name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space
                    TextFormField(
                      // New field for handle
                      controller: _handleController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Unique Handle",
                        border: OutlineInputBorder(),
                        prefixText: "@",
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a handle';
                        }
                        if (value.trim().length < 3) {
                          return 'Handle must be at least 3 characters';
                        }
                        // Basic validation for allowed characters
                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                          return 'Only letters, numbers, and underscores allowed';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _createUser,
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Continue"),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text(state.runtimeType.toString()));
        },
      ),
    );
  }

  Widget avatarView(int index, String url) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0.0);
          value = (value * 0.1).clamp(-1, 1);
        }
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()..rotateZ(pi * value)..scale(1 -(value.abs()*3))..translate(-value*500,-value.abs()*300),
          child: avatarSvg(url),
        );
      },
    );
  }

  Widget avatarSvg(String url) {
    return SvgPicture.network(
      url,
      fit: BoxFit.fitHeight,
      placeholderBuilder:
          (BuildContext context) => Container(
            padding: const EdgeInsets.all(11.0),
            child: const CircularProgressIndicator(),
          ),
    );
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final handle = _handleController.text.trim();
      context.read<UserBloc>().add(
        CreateUserInFirestoreEvent(
          uid: widget.uid,
          phone: widget.phone,
          displayName: name,
          userHandle: handle,
        ),
      );
    }
  }
}
