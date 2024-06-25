import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;

  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, address];
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String firstName;
  final String lastName;
  final String email;
  final String address;

  const ProfileLoaded({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
  });

  @override
  List<Object> get props => [firstName, lastName, email, address];
}

class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final bool useApi;

  ProfileBloc({this.useApi = false}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response = await http.get(Uri.parse(''));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(ProfileLoaded(
            firstName: data['firstName'],
            lastName: data['lastName'],
            email: data['email'],
            address: data['address'],
          ));
        } else {
          emit(const ProfileError('Failed to load profile data'));
        }
      } else {
        // Placeholder data
        await Future.delayed(const Duration(seconds: 1));
        emit(const ProfileLoaded(
          firstName: 'Chimdimma',
          lastName: 'Nwobu',
          email: 'chimdimma.nwobu@ecr-ts.com',
          address: '74A Road 5, Federal Low-cost Housing Estate Umuahia',
        ));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'firstName': event.firstName,
            'lastName': event.lastName,
            'email': event.email,
            'password': event.password,
            'address': event.address,
          }),
        );

        if (response.statusCode == 200) {
          emit(ProfileUpdated());
          emit(ProfileLoaded(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
            address: event.address,
          ));
        } else {
          emit(const ProfileError('Failed to update profile'));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(ProfileUpdated());
        emit(ProfileLoaded(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          address: event.address,
        ));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(text: '********');
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  void _updateProfile() {
    context.read<ProfileBloc>().add(
          UpdateProfile(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            address: _addressController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            _firstNameController.text = state.firstName;
            _lastNameController.text = state.lastName;
            _emailController.text = state.email;
            _addressController.text = state.address;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_image.png'),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _addressController,
                      label: 'Address',
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'EDIT PROFILE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (state is ProfileUpdated)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Profile updated successfully',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
