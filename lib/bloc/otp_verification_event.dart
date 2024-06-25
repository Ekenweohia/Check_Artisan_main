
import 'package:equatable/equatable.dart';

abstract class OTPVerificationEvent extends Equatable {
  const OTPVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyOTP extends OTPVerificationEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOTP(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class ResendOTP extends OTPVerificationEvent {
  final String phoneNumber;

  const ResendOTP(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
