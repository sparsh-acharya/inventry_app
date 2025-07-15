// features/auth/presentation/pages/phone_verification_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class PhoneVerificationPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  PhoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+91 ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final phone = "+91${phoneController.text.trim()}";
                context.read<AuthBloc>().add(SendOTPEvent(phoneNumber: phone));
              },
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
