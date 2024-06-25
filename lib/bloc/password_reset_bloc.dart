import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'password_reset_event.dart';
import 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc() : super(PasswordResetInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onSendPasswordResetEmail(
      SendPasswordResetEmail event, Emitter<PasswordResetState> emit) async {
    emit(PasswordResetLoading());

    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/password_reset'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': event.email,
        }),
      );

      if (response.statusCode == 200) {
        emit(PasswordResetSuccess());
      } else {
        final error = jsonDecode(response.body)['error'];
        emit(PasswordResetFailure(error));
      }
    } catch (e) {
      emit(PasswordResetFailure(e.toString()));
    }
  }
}
