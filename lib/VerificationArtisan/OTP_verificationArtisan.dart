import 'package:check_artisan/profile/complete_profile_artisan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sms_autofill/sms_autofill.dart';

abstract class OTPVerificationArtisanEvent extends Equatable {
  const OTPVerificationArtisanEvent();

  @override
  List<Object> get props => [];
}

class VerifyOTP extends OTPVerificationArtisanEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOTP(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class ResendOTP extends OTPVerificationArtisanEvent {
  final String phoneNumber;

  const ResendOTP(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

abstract class OTPVerificationArtisanState extends Equatable {
  const OTPVerificationArtisanState();

  @override
  List<Object> get props => [];
}

class OTPVerificationInitial extends OTPVerificationArtisanState {}

class OTPVerificationLoading extends OTPVerificationArtisanState {}

class OTPVerificationSuccess extends OTPVerificationArtisanState {}

class OTPVerificationFailure extends OTPVerificationArtisanState {
  final String error;

  const OTPVerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class OTPResent extends OTPVerificationArtisanState {}

class OTPVerificationBloc
    extends Bloc<OTPVerificationArtisanEvent, OTPVerificationArtisanState> {
  final bool useApi;

  OTPVerificationBloc({this.useApi = false}) : super(OTPVerificationInitial()) {
    on<VerifyOTP>(_onVerifyOTP);
    on<ResendOTP>(_onResendOTP);
  }

  Future<void> _onVerifyOTP(
      VerifyOTP event, Emitter<OTPVerificationArtisanState> emit) async {
    emit(OTPVerificationLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API TO SEND OTP
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
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(OTPVerificationSuccess());
      }
    } catch (e) {
      emit(OTPVerificationFailure(e.toString()));
    }
  }

  Future<void> _onResendOTP(
      ResendOTP event, Emitter<OTPVerificationArtisanState> emit) async {
    emit(OTPVerificationLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API TO RESEND OTP
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
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(OTPResent());
      }
    } catch (e) {
      emit(OTPVerificationFailure(e.toString()));
    }
  }
}

class OTPVerificationArtisanScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationArtisanScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  OTPVerificationArtisanScreenState createState() =>
      OTPVerificationArtisanScreenState();
}

class OTPVerificationArtisanScreenState
    extends State<OTPVerificationArtisanScreen> with CodeAutoFill {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      _otpController1.text = code![0];
      _otpController2.text = code![1];
      _otpController3.text = code![2];
      _otpController4.text = code![3];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => OTPVerificationBloc(
            useApi: false), // Change to true when API is ready
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/otp.png',
                  width: 400,
                  height: 400,
                ),
                const SizedBox(height: 20),
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter the OTP sent to ${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _otpTextField(_otpController1, true),
                    _otpTextField(_otpController2, false),
                    _otpTextField(_otpController3, false),
                    _otpTextField(_otpController4, false),
                  ],
                ),
                const SizedBox(height: 20),
                BlocConsumer<OTPVerificationBloc, OTPVerificationArtisanState>(
                  listener: (context, state) {
                    if (state is OTPVerificationSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompleteProfile()),
                      );
                    } else if (state is OTPVerificationFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    } else if (state is OTPResent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP resent!')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is OTPVerificationLoading) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<OTPVerificationBloc>()
                                .add(ResendOTP(widget.phoneNumber));
                          },
                          child: const Text(
                            'Didn’t receive OTP? RESEND',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF004D40),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final otp = _otpController1.text +
                                  _otpController2.text +
                                  _otpController3.text +
                                  _otpController4.text;
                              context
                                  .read<OTPVerificationBloc>()
                                  .add(VerifyOTP(widget.phoneNumber, otp));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004D40),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('VERIFY'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(TextEditingController controller, bool autoFocus) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
