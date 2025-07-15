# Inventory App - Phone Authentication

A Flutter application with Firebase phone authentication using clean architecture and BLoC state management.

## Features

- ✅ Phone number verification using Firebase Auth
- ✅ Clean Architecture (Data, Domain, Presentation layers)
- ✅ BLoC state management
- ✅ Feature-first folder structure
- ✅ Dependency injection
- ✅ Modern UI with Material Design 3

## Architecture

The app follows clean architecture principles with feature-first organization:

```
lib/
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasource/
│       │   │   └── auth_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repo/
│       │       └── auth_repository_impl.dart
│       ├── domain/
│       │   ├── entity/
│       │   │   └── user_entity.dart
│       │   ├── repo/
│       │   │   └── auth_repository.dart
│       │   └── usecase/
│       │       ├── get_current_user_usecase.dart
│       │       ├── send_phone_verification_usecase.dart
│       │       ├── sign_out_usecase.dart
│       │       └── verify_phone_code_usecase.dart
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── auth_bloc.dart
│       │   │   ├── auth_event.dart
│       │   │   └── auth_state.dart
│       │   ├── pages/
│       │   │   ├── phone_verification_page.dart
│       │   │   ├── otp_verification_page.dart
│       │   │   └── home_page.dart
│       │   └── widgets/
│       │       ├── phone_input_widget.dart
│       │       └── otp_input_widget.dart
│       └── di/
│           └── auth_injection.dart
├── firebase_options.dart
└── main.dart
```

## Setup Instructions

### 1. Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Android/iOS app to the project
3. Download the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
4. Enable Phone Authentication in Firebase Console:
   - Go to Authentication > Sign-in method
   - Enable Phone Number provider
   - Add test phone numbers if needed

### 2. Dependencies

The following dependencies are already included in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_auth: ^5.6.2
  firebase_core: ^3.15.1
  flutter_bloc: ^9.1.1
  equatable: ^2.0.5
```

### 3. Run the App

```bash
flutter pub get
flutter run
```

## Usage

1. **Phone Verification**: Enter your phone number to receive a verification code
2. **OTP Verification**: Enter the 6-digit code sent to your phone
3. **Authentication**: Once verified, you'll be redirected to the home page
4. **Sign Out**: Use the logout button in the app bar to sign out

## Key Components

### Domain Layer
- **UserEntity**: Core user data model
- **AuthRepository**: Abstract interface for authentication operations
- **Use Cases**: Business logic for authentication operations

### Data Layer
- **AuthRemoteDataSource**: Firebase Auth implementation
- **UserModel**: Data model extending UserEntity
- **AuthRepositoryImpl**: Repository implementation

### Presentation Layer
- **AuthBloc**: State management for authentication
- **AuthEvent**: Events for authentication operations
- **AuthState**: States for authentication flow
- **Pages**: UI screens for phone verification and OTP
- **Widgets**: Reusable UI components

## State Management

The app uses BLoC pattern for state management:

- **AuthInitial**: Initial state
- **AuthLoading**: Loading state during operations
- **PhoneVerificationSent**: When verification code is sent
- **AuthSuccess**: When user is authenticated
- **AuthFailure**: When authentication fails
- **AuthSignedOut**: When user signs out

## Error Handling

The app includes comprehensive error handling:
- Network errors
- Invalid phone numbers
- Invalid OTP codes
- Firebase authentication errors

## Testing

To test the phone authentication:
1. Use a real phone number for production testing
2. Use test phone numbers configured in Firebase Console for development
3. Firebase provides test OTP codes for development

## Security Considerations

- Phone numbers are validated before sending verification codes
- OTP codes are handled securely through Firebase
- User sessions are managed by Firebase Auth
- Sign out functionality clears user session

## Future Enhancements

- [ ] Add email authentication
- [ ] Implement user profile management
- [ ] Add biometric authentication
- [ ] Implement offline support
- [ ] Add unit and widget tests
- [ ] Implement proper error handling with retry mechanisms

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Ensure `firebase_options.dart` is properly configured
2. **Phone verification fails**: Check if phone authentication is enabled in Firebase Console
3. **OTP not received**: Verify phone number format and Firebase configuration
4. **Build errors**: Run `flutter clean` and `flutter pub get`

### Debug Mode

For development, you can use test phone numbers and Firebase will provide test OTP codes in the console.

## License

This project is for educational purposes. Feel free to use and modify as needed.
