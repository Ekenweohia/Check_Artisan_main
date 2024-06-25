import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:check_artisan/VerificationClient/OTP_verification.dart';
import 'package:check_artisan/RegistrationClient/login_client.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class SubmitRegistration extends RegistrationEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;

  const SubmitRegistration({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, phoneNumber, password];
}

class GoogleLogin extends RegistrationEvent {}

class FacebookLogin extends RegistrationEvent {}

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;

  const RegistrationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final bool useApi;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  RegistrationBloc({this.useApi = false}) : super(RegistrationInitial()) {
    on<SubmitRegistration>(_onSubmitRegistration);
    on<GoogleLogin>(_onGoogleLogin);
    on<FacebookLogin>(_onFacebookLogin);
  }

  Future<void> _onSubmitRegistration(
      SubmitRegistration event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API URL for registration
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'firstName': event.firstName,
            'lastName': event.lastName,
            'phoneNumber': event.phoneNumber,
            'password': event.password,
          }),
        );

        if (response.statusCode == 200) {
          emit(RegistrationSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(RegistrationFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(RegistrationSuccess());
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLogin(
      GoogleLogin event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('Google sign-in failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onFacebookLogin(
      FacebookLogin event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('Facebook sign-in failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}

class PhoneClient extends StatefulWidget {
  const PhoneClient({Key? key}) : super(key: key);

  @override
  PhoneClientState createState() => PhoneClientState();
}

class PhoneClientState extends State<PhoneClient> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/reg screen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color(0xF2004D40),
          ),
          Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset(
                  'assets/icons/logo checkartisan 1.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  child: SingleChildScrollView(
                    child: BlocProvider(
                      create: (context) => RegistrationBloc(
                          useApi:
                              false), // will be Change to true when API is ready
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Got a Phone Number? Let’s Get Started',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              labelText: 'First Name',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              labelText: 'Last Name',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              labelText: 'Phone Number',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'CLICK HERE TO READ TERMS AND CONDITIONS',
                            style: TextStyle(
                              color: Color(0xFF004D40),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Switch(
                                value: false,
                                onChanged: (bool value) {},
                              ),
                              const Text('I agree to the terms and conditions'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BlocConsumer<RegistrationBloc, RegistrationState>(
                            listener: (context, state) {
                              if (state is RegistrationSuccess) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OTPVerificationScreen(
                                      phoneNumber: _phoneController.text,
                                    ),
                                  ),
                                );
                              } else if (state is RegistrationFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${state.error}')),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is RegistrationLoading) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final firstName = _firstNameController.text;
                                    final lastName = _lastNameController.text;
                                    final phoneNumber = _phoneController.text;
                                    final password = _passwordController.text;
                                    final confirmPassword =
                                        _confirmPasswordController.text;

                                    if (password != confirmPassword) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Passwords do not match')),
                                      );
                                      return;
                                    }

                                    context.read<RegistrationBloc>().add(
                                          SubmitRegistration(
                                            firstName: firstName,
                                            lastName: lastName,
                                            phoneNumber: phoneNumber,
                                            password: password,
                                          ),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF004D40),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text('SIGN UP'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlocBuilder<RegistrationBloc, RegistrationState>(
                                builder: (context, state) {
                                  return ElevatedButton.icon(
                                    onPressed: () {
                                      context
                                          .read<RegistrationBloc>()
                                          .add(GoogleLogin());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'assets/icons/google.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    label: const Text('Google account'),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              BlocBuilder<RegistrationBloc, RegistrationState>(
                                builder: (context, state) {
                                  return ElevatedButton.icon(
                                    onPressed: () {
                                      context
                                          .read<RegistrationBloc>()
                                          .add(FacebookLogin());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'assets/icons/facebook.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    label: const Text('Facebook account'),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginClient(),
                                ),
                              );
                            },
                            child: const Text(
                              'Already Have an account? LOGIN',
                              style: TextStyle(
                                color: Color(0xFF004D40),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
