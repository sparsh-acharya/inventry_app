// lib/features/auth/presentation/pages/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/core/firebase/firebase_messaging.dart';
import 'package:inventry_app/features/group/presentation/pages/home_page.dart';
import 'package:inventry_app/features/auth/presentation/pages/otp_page.dart';
import 'package:inventry_app/features/auth/presentation/pages/phone_page.dart';
import '../bloc/auth_bloc.dart';
import 'package:inventry_app/features/user/presentation/pages/new_user_onboarding_page.dart';
import 'package:inventry_app/features/user/presentation/bloc/user_bloc.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // bool _hasTriggeredUserCheck = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is OtpSentState &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthenticatedState) {
            final user = authState.user;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<UserBloc>().add(IsNewUserEvent(uid: user.uid));
            });

            // if (!_hasTriggeredUserCheck) {
            //   _hasTriggeredUserCheck = true;
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     context.read<UserBloc>().add(IsNewUserEvent(uid: user.uid));
            //   });
            // }

            return BlocConsumer<UserBloc, UserState>(
              listener: (context, userState) {
                if (userState is UserCreatedInFirestore) {
                  context.read<UserBloc>().add(LoadUserEvent());
                }
              },
              builder: (context, userState) {
                if (userState is UserLoading) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator(color: Colors.green,)),
                  );
                } else if (userState is NewUserState || userState is AvatarsLoaded) {
                  return NewUserOnboardingPage(
                    uid: user.uid,
                    phone: user.phoneNumber,
                  );
                } else if (userState is UserLoaded) {
                  NotificationServices().initNotifications(context);
                  return HomePage(user: userState.user);
                } else if (userState is UserError) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${userState.message}'),
                          ElevatedButton(
                            onPressed: () {
                              context.read<UserBloc>().add(
                                IsNewUserEvent(uid: user.uid),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const Scaffold(
                  body: Center(child: CircularProgressIndicator(color: Colors.green,)),
                );
              },
            );
          } else if (authState is AuthLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.green,)),
            );
          } else if (authState is OtpSentState) {
            return OtpVerificationPage(
              verificationId: authState.verificationId,
            );
          } else {
            // _hasTriggeredUserCheck = false;
            return PhoneVerificationPage();
          }
        },
      ),
    );
  }
}
