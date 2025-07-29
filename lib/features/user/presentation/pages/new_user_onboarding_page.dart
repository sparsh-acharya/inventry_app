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

class _NewUserOnboardingPageState extends State<NewUserOnboardingPage>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _handleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late PageController _pageController;
  final int _initialPage = 120;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _avatarController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _avatarScale;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.6,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the controller is still mounted before using it
      if (_pageController.hasClients) {
        // This notifies listeners to rebuild now that dimensions are available
        _pageController.jumpToPage(_initialPage);
      }
    });

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _avatarScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Load avatars
    context.read<UserBloc>().add(FetchAvatarsEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.secondary,
              theme.colorScheme.secondary.withOpacity(0.8),
              theme.colorScheme.primary.withOpacity(0.6),
              theme.colorScheme.background,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AvatarsLoading) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.account_circle_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Loading avatars...',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is AvatarsLoaded) {
                final isLoading = state is UserLoading;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight:
                          size.height - MediaQuery.of(context).padding.top,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Premium Header Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback:
                                    (bounds) => const LinearGradient(
                                      colors: [Colors.white, Color(0xFFE8E8E8)],
                                    ).createShader(bounds),
                                child: Text(
                                  "Create Your Profile",
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontSize: 32,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Choose your avatar and set up your profile to get started with InventryApp",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Premium Avatar Selection
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child:
                                state.avatars.isEmpty
                                    ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: PageView.builder(
                                        itemCount: 10000,
                                        physics: const BouncingScrollPhysics(),
                                        controller: _pageController,
                                        itemBuilder: (context, index) {
                                          final avatarIndex =
                                              index % state.avatars.length;
                                          return _buildAvatarView(
                                            index,
                                            state.avatars[avatarIndex].url,
                                          );
                                        },
                                      ),
                                    ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Premium Form Card
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Profile Information",
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Display Name Field
                                    _buildPremiumTextField(
                                      controller: _nameController,
                                      label: "Display Name",
                                      hint: "Enter your display name",
                                      icon: Icons.person_rounded,
                                      enabled: !isLoading,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Please enter your display name';
                                        }
                                        if (value.trim().length < 2) {
                                          return 'Name must be at least 2 characters';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 20),

                                    // Handle Field
                                    _buildPremiumTextField(
                                      controller: _handleController,
                                      label: "Unique Handle",
                                      hint: "Enter your unique handle",
                                      icon: Icons.alternate_email_rounded,
                                      enabled: !isLoading,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Please enter a handle';
                                        }
                                        if (value.trim().length < 3) {
                                          return 'Handle must be at least 3 characters';
                                        }
                                        if (!RegExp(
                                          r'^[a-zA-Z0-9_]+$',
                                        ).hasMatch(value)) {
                                          return 'Only letters, numbers, and underscores allowed';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 32),

                                    // Premium Continue Button
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors:
                                              isLoading
                                                  ? [
                                                    Colors.grey.withOpacity(
                                                      0.3,
                                                    ),
                                                    Colors.grey.withOpacity(
                                                      0.2,
                                                    ),
                                                  ]
                                                  : [
                                                    theme.colorScheme.tertiary,
                                                    theme.colorScheme.tertiary
                                                        .withOpacity(0.8),
                                                  ],
                                        ),
                                        boxShadow:
                                            isLoading
                                                ? []
                                                : [
                                                  BoxShadow(
                                                    color: theme
                                                        .colorScheme
                                                        .tertiary
                                                        .withOpacity(0.4),
                                                    blurRadius: 15,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                            isLoading
                                                ? null
                                                : () =>
                                                    _createUser(state.avatars),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child:
                                            isLoading
                                                ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                                : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .rocket_launch_rounded,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Get Started",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Footer
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            "Your profile information helps us personalize your experience",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Text(
                    'Something went wrong',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefix,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
          ),
          border: InputBorder.none,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
              width: 0.8,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarView(int index, String url) {
    return ScaleTransition(
      scale: _avatarScale,
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0.0;
          if (_pageController.position.haveDimensions) {
            value = index.toDouble() - (_pageController.page ?? 0.0);
            value = (value * 0.1).clamp(-1, 1);
          }
          return Transform(
            alignment: FractionalOffset.center,
            transform:
                Matrix4.identity()
                  ..rotateZ(pi * value * 1.5)
                  ..scale(1 - (value.abs() * 0.3))
                  ..translate(-value * 50, value.abs() * 700),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: SvgPicture.network(
                  url,
                  fit: BoxFit.cover,
                  placeholderBuilder:
                      (BuildContext context) => Container(
                        padding: const EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: Colors.white.withOpacity(0.7),
                          strokeWidth: 2,
                        ),
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _createUser(List<AvatarEntity> avatars) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final handle = _handleController.text.trim();
      final photoUrl =
          _pageController.hasClients && avatars.isNotEmpty
              ? avatars[_pageController.page!.round() % avatars.length].url
              : null;
      context.read<UserBloc>().add(
        CreateUserInFirestoreEvent(
          uid: widget.uid,
          phone: widget.phone,
          displayName: name,
          userHandle: handle,
          avatarUrl: photoUrl,
        ),
      );
    }
  }
}
