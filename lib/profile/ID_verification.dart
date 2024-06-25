import 'package:check_artisan/loginsignupclient/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class IDVerificationEvent extends Equatable {
  const IDVerificationEvent();

  @override
  List<Object> get props => [];
}

class UploadDocument extends IDVerificationEvent {
  final File document;

  const UploadDocument(this.document);

  @override
  List<Object> get props => [document];
}

abstract class IDVerificationStatus extends Equatable {
  const IDVerificationStatus();

  @override
  List<Object> get props => [];
}

class IDVerificationInitial extends IDVerificationStatus {}

class IDVerificationLoading extends IDVerificationStatus {}

class IDVerificationSuccess extends IDVerificationStatus {}

class IDVerificationFailure extends IDVerificationStatus {
  final String error;

  const IDVerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class IDVerificationBloc
    extends Bloc<IDVerificationEvent, IDVerificationStatus> {
  final bool useApi;

  IDVerificationBloc({this.useApi = false}) : super(IDVerificationInitial()) {
    on<UploadDocument>(_onUploadDocument);
  }

  Future<void> _onUploadDocument(
      UploadDocument event, Emitter<IDVerificationStatus> emit) async {
    emit(IDVerificationLoading());

    try {
      if (useApi) {
        final bytes = await event.document.readAsBytes();
        final base64Image = base64Encode(bytes);

        final response = await http.post(
          Uri.parse(''),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'document': base64Image,
            'fileName': event.document.path.split('/').last,
            'fileType': 'image/${event.document.path.split('.').last}',
          }),
        );

        if (response.statusCode == 200) {
          emit(IDVerificationSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(IDVerificationFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(IDVerificationSuccess());
      }
    } catch (e) {
      emit(IDVerificationFailure(e.toString()));
    }
  }
}

class IDVerification extends StatefulWidget {
  const IDVerification({Key? key}) : super(key: key);

  @override
  IDVerificationState createState() => IDVerificationState();
}

class IDVerificationState extends State<IDVerification> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _continue() {
    if (_selectedFile == null) {
      _showErrorDialog('Please upload a document to continue.');
    } else {
      context.read<IDVerificationBloc>().add(UploadDocument(_selectedFile!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload your credentials',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload any credentials / government issued ID for verification purposes.\nE.g - Drivers license, NIN, voter’s card etc.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: _selectedFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 40, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              '(Jpeg/ PNG/ PDF)',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Image.file(
                          _selectedFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt, color: Color(0xFF004D40)),
                label: const Text(
                  'Add Document',
                  style: TextStyle(color: Color(0xFF004D40)),
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<IDVerificationBloc, IDVerificationStatus>(
                listener: (context, state) {
                  if (state is IDVerificationSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else if (state is IDVerificationFailure) {
                    _showErrorDialog(state.error);
                  }
                },
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF004D40),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Color(0xFF004D40)),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Continue'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
