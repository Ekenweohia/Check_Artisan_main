import 'package:check_artisan/profile/complete_profile_artisan.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerificationArtisan extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationArtisan({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  OTPVerificationArtisanState createState() => OTPVerificationArtisanState();
}

class OTPVerificationArtisanState extends State<OTPVerificationArtisan>
    with CodeAutoFill {
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
    if (code!.length == 4) {
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
      body: Center(
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
              TextButton(
                onPressed: () {},
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompleteProfile()),
                    );
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
