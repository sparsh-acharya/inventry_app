import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';
import 'package:inventry_app/features/auth/domain/usecase/get_currentuser_usecase.dart';
import 'package:inventry_app/features/auth/domain/usecase/send_otp_usecase.dart';
import 'package:inventry_app/features/auth/domain/usecase/signout_usecase.dart';
import 'package:inventry_app/features/auth/domain/usecase/verify_opt_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUsecase sendOtp;
  final VerifyOptUsecase verifyOtp;
  final GetCurrentuserUsecase getCurrentUser;
  final SignoutUsecase signOut;

  AuthBloc({
    required this.sendOtp,
    required this.verifyOtp,
    required this.getCurrentUser,
    required this.signOut,
  }) : super(AuthInitialState()) {
    on<SendOTPEvent>(_onSendOtp);
    on<VerifyOTPEvent>(_onVerifyOtp);
    on<AutoVerifiedEvent>(_onAutoVerified);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<SignOutEvent>(_onSignOut);
    on<OtpSentEvent>(_onOtpSent);
  }

  Future<void> _onSendOtp(SendOTPEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await sendOtp(
      SendOTPParams(
        phone: event.phoneNumber,
        onCodeSent: (verificationId) {
          add(OtpSentEvent(verificationId));
        },
        onAutoVerified: (uid) {
          add(AutoVerifiedEvent(uid));
        },
      ),
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) {}, // handled in callbacks
    );
  }

  void _onOtpSent(OtpSentEvent event, Emitter<AuthState> emit) {
    emit(OtpSentState(event.verificationId));
  }

  Future<void> _onVerifyOtp(
    VerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    final result = await verifyOtp(
      VerifyOTPParam(verificationId: event.verificationID, otp: event.otp),
    );

    result.fold(
      (failure) => emit(
        OtpSentState(event.verificationID, errorMessage: failure.message),
      ),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  Future<void> _onAutoVerified(
    AutoVerifiedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser(NoParams());
    UserEntity? user;
    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (entity) => user = entity,
    );

    if (user != null) {
      emit(AuthenticatedState(user!));
    } else {
      emit(AuthErrorState("Auto verification failed."));
    }
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser(NoParams());
    UserEntity? user;
    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (entity) => user = entity,
    );

    if (user != null) {
      emit(AuthenticatedState(user!));
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await signOut(NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) => emit(UnauthenticatedState()),
    );
  }
}
