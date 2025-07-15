// features/auth/presentation/pages/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/auth/presentation/pages/home_page.dart';
import 'package:inventry_app/features/auth/presentation/pages/otp_page.dart';
import 'package:inventry_app/features/auth/presentation/pages/phone_page.dart';
import '../bloc/auth_bloc.dart';
import 'package:inventry_app/features/user/presentation/pages/new_user_onboarding_page.dart';
import 'package:inventry_app/features/user/presentation/bloc/user_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is OtpSentState && state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthenticatedState) {
            final user = state.user;
            // Dispatch IsNewUserEvent only once
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if(state is NewUserState){
                  return Scaffold(body: Text('new user'),);
                }
                else{
                  return HomePage(uid: user.uid);
                }
              },
            );
          } else if (state is AuthLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is OtpSentState) {
            return OtpVerificationPage(verificationId: state.verificationId);
          } else {
            return PhoneVerificationPage();
          }
        },
      ),
    );
  }
}
