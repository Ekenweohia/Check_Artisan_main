import 'package:equatable/equatable.dart';

abstract class OTPVerificationState extends Equatable {
  const OTPVerificationState();

  @override
  List<Object> get props => [];
}

class OTPVerificationInitial extends OTPVerificationState {}

class OTPVerificationLoading extends OTPVerificationState {}

class OTPVerificationSuccess extends OTPVerificationState {}

class OTPVerificationFailure extends OTPVerificationState {
  final String error;

  const OTPVerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class OTPResent extends OTPVerificationState {}
