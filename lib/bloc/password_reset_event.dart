import 'package:equatable/equatable.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class SendPasswordResetEmail extends PasswordResetEvent {
  final String email;

  const SendPasswordResetEmail(this.email);

  @override
  List<Object> get props => [email];
}
