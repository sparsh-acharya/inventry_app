// features/auth/presentation/pages/otp_verification_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class OtpVerificationPage extends StatelessWidget {
  final String verificationId;
  final TextEditingController otpController = TextEditingController();

  OtpVerificationPage({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final otp = otpController.text.trim();
                context.read<AuthBloc>().add(
                  VerifyOTPEvent(verificationID: verificationId, otp: otp),
                );
              },
              child: const Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
