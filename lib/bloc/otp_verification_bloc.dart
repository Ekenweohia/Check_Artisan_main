import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'otp_verification_event.dart';
import 'otp_verification_state.dart';

class OTPVerificationBloc
    extends Bloc<OTPVerificationEvent, OTPVerificationState> {
  OTPVerificationBloc() : super(OTPVerificationInitial()) {
    on<VerifyOTP>(_onVerifyOTP);
    on<ResendOTP>(_onResendOTP);
  }

  Future<void> _onVerifyOTP(
      VerifyOTP event, Emitter<OTPVerificationState> emit) async {
    emit(OTPVerificationLoading());

    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/verify_otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': event.phoneNumber,
          'otp': event.otp,
        }),
      );

      if (response.statusCode == 200) {
        emit(OTPVerificationSuccess());
      } else {
        final error = jsonDecode(response.body)['error'];
        emit(OTPVerificationFailure(error));
      }
    } catch (e) {
      emit(OTPVerificationFailure(e.toString()));
    }
  }

  Future<void> _onResendOTP(
      ResendOTP event, Emitter<OTPVerificationState> emit) async {
    emit(OTPVerificationLoading());

    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/resend_otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': event.phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        emit(OTPResent());
      } else {
        final error = jsonDecode(response.body)['error'];
        emit(OTPVerificationFailure(error));
      }
    } catch (e) {
      emit(OTPVerificationFailure(e.toString()));
    }
  }
}
