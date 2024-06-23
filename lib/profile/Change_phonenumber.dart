import 'package:check_artisan/VerificationClient/OTP_verification.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({Key? key}) : super(key: key);

  @override
  ChangePhoneNumberState createState() => ChangePhoneNumberState();
}

class ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final TextEditingController _oldPhoneNumberController =
      TextEditingController();
  final TextEditingController _newPhoneNumberController =
      TextEditingController();

  @override
  void dispose() {
    _oldPhoneNumberController.dispose();
    _newPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Phone Number'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 70),
            TextField(
              controller: _oldPhoneNumberController,
              decoration: InputDecoration(
                labelText: 'Old Phone Number',
                hintStyle: const TextStyle(color: Color(0xFF004D40)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: const TextStyle(color: Color(0xFF004D40)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPhoneNumberController,
              decoration: InputDecoration(
                labelText: 'New Phone Number',
                hintStyle: const TextStyle(color: Color(0xFF004D40)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: const TextStyle(color: Color(0xFF004D40)),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_newPhoneNumberController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPVerification(
                          phoneNumber: _newPhoneNumberController.text,
                        ),
                      ),
                    );
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'GENERATE OTP',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
