import 'package:check_artisan/profile/ID_verification.dart';
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

class LoadProfileData extends ProfileEvent {}

class SubmitProfileStep1 extends ProfileEvent {
  final String businessName;
  final String location;
  final String tradeType;
  final List<String> skills;
  final String country;
  final String state;
  final String city;
  final String distance;

  const SubmitProfileStep1({
    required this.businessName,
    required this.location,
    required this.tradeType,
    required this.skills,
    required this.country,
    required this.state,
    required this.city,
    required this.distance,
  });

  @override
  List<Object> get props => [
        businessName,
        location,
        tradeType,
        skills,
        country,
        state,
        city,
        distance,
      ];
}

class SubmitProfileStep2 extends ProfileEvent {
  final String businessDescription;
  final bool textAlert;
  final bool emailAlert;
  final bool newsletterSubscription;

  const SubmitProfileStep2({
    required this.businessDescription,
    required this.textAlert,
    required this.emailAlert,
    required this.newsletterSubscription,
  });

  @override
  List<Object> get props => [
        businessDescription,
        textAlert,
        emailAlert,
        newsletterSubscription,
      ];
}

// Define States for both steps
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<String> tradeTypes;
  final List<String> skills;
  final List<String> countries;
  final List<String> states;
  final List<String> cities;
  final List<String> distances;

  const ProfileLoaded({
    required this.tradeTypes,
    required this.skills,
    required this.countries,
    required this.states,
    required this.cities,
    required this.distances,
  });

  @override
  List<Object> get props => [
        tradeTypes,
        skills,
        countries,
        states,
        cities,
        distances,
      ];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileStep1Submitted extends ProfileState {}

class ProfileStep2Loaded extends ProfileState {
  final String businessDescription;
  final bool textAlert;
  final bool emailAlert;
  final bool newsletterSubscription;

  const ProfileStep2Loaded({
    required this.businessDescription,
    required this.textAlert,
    required this.emailAlert,
    required this.newsletterSubscription,
  });

  @override
  List<Object> get props => [
        businessDescription,
        textAlert,
        emailAlert,
        newsletterSubscription,
      ];
}

class ProfileStep2Submitted extends ProfileState {}

// Define BLoC for handling both steps
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final bool useApi;

  ProfileBloc({this.useApi = false}) : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<SubmitProfileStep1>(_onSubmitProfileStep1);
    on<SubmitProfileStep2>(_onSubmitProfileStep2);
  }

  Future<void> _onLoadProfileData(
      LoadProfileData event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response =
            await http.get(Uri.parse('https://yourapiendpoint.com/data'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(ProfileLoaded(
            tradeTypes: List<String>.from(data['tradeTypes']),
            skills: List<String>.from(data['skills']),
            countries: List<String>.from(data['countries']),
            states: List<String>.from(data['states']),
            cities: List<String>.from(data['cities']),
            distances: List<String>.from(data['distances']),
          ));
        } else {
          emit(const ProfileError('Failed to load data, try again'));
        }
      } else {
        // Placeholder data
        await Future.delayed(const Duration(seconds: 1));
        emit(const ProfileLoaded(
          tradeTypes: [
            'Carpenter',
            'Electrician',
            'Plumber',
            'Painter',
            'Others'
          ],
          skills: [
            'Wedding Event Planning',
            'Catering Services',
            'Decoration',
            'Others'
          ],
          countries: ['Country 1', 'Country 2', 'Country 3'],
          states: ['State 1', 'State 2', 'State 3'],
          cities: ['City 1', 'City 2', 'City 3'],
          distances: ['5 km', '10 km', '15 km'],
        ));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSubmitProfileStep1(
      SubmitProfileStep1 event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse('https://yourapiendpoint.com/submit'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'businessName': event.businessName,
            'location': event.location,
            'tradeType': event.tradeType,
            'skills': event.skills,
            'country': event.country,
            'state': event.state,
            'city': event.city,
            'distance': event.distance,
          }),
        );

        if (response.statusCode == 200) {
          emit(ProfileStep1Submitted());
          emit(const ProfileStep2Loaded(
            businessDescription: '',
            textAlert: false,
            emailAlert: false,
            newsletterSubscription: false,
          ));
        } else {
          emit(const ProfileError('Failed to submit data'));
        }
      } else {
        // Simulate successful submission
        await Future.delayed(const Duration(seconds: 1));
        emit(ProfileStep1Submitted());
        emit(const ProfileStep2Loaded(
          businessDescription: '',
          textAlert: false,
          emailAlert: false,
          newsletterSubscription: false,
        ));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSubmitProfileStep2(
      SubmitProfileStep2 event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse('https://yourapiendpoint.com/submit2'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'businessDescription': event.businessDescription,
            'textAlert': event.textAlert,
            'emailAlert': event.emailAlert,
            'newsletterSubscription': event.newsletterSubscription,
          }),
        );

        if (response.statusCode == 200) {
          emit(ProfileStep2Submitted());
        } else {
          emit(const ProfileError('Failed to submit data'));
        }
      } else {
        // Simulate successful submission
        await Future.delayed(const Duration(seconds: 1));
        emit(ProfileStep2Submitted());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

// Define CompleteProfile Screen
class CompleteProfile2 extends StatefulWidget {
  const CompleteProfile2({Key? key}) : super(key: key);

  @override
  CompleteProfile2State createState() => CompleteProfile2State();
}

class CompleteProfile2State extends State<CompleteProfile2> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  String? _selectedTradeType;
  final List<String> _selectedSkills = [];
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedDistance;
  bool _textAlert = false;
  bool _emailAlert = false;
  bool _newsletterSubscription = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  void _submitProfileStep1() {
    context.read<ProfileBloc>().add(
          SubmitProfileStep1(
            businessName: _businessNameController.text,
            location: _locationController.text,
            tradeType: _selectedTradeType!,
            skills: _selectedSkills,
            country: _selectedCountry!,
            state: _selectedState!,
            city: _selectedCity!,
            distance: _selectedDistance!,
          ),
        );
  }

  void _submitProfileStep2() {
    context.read<ProfileBloc>().add(
          SubmitProfileStep2(
            businessDescription: _businessDescriptionController.text,
            textAlert: _textAlert,
            emailAlert: _emailAlert,
            newsletterSubscription: _newsletterSubscription,
          ),
        );
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
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ProfileLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _businessNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'Business name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'Location',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'Artisan trade type',
                          ),
                          value: _selectedTradeType,
                          items: state.tradeTypes
                              .map((type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTradeType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Artisan skill',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        ...state.skills.map((skill) => CheckboxListTile(
                              title: Text(skill),
                              value: _selectedSkills.contains(skill),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedSkills.add(skill);
                                  } else {
                                    _selectedSkills.remove(skill);
                                  }
                                });
                              },
                            )),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'Country',
                          ),
                          value: _selectedCountry,
                          items: state.countries
                              .map((country) => DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'State',
                          ),
                          value: _selectedState,
                          items: state.states
                              .map((state) => DropdownMenuItem<String>(
                                    value: state,
                                    child: Text(state),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedState = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'City',
                          ),
                          value: _selectedCity,
                          items: state.cities
                              .map((city) => DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText:
                                'What distance are you willing to travel?',
                          ),
                          value: _selectedDistance,
                          items: state.distances
                              .map((distance) => DropdownMenuItem<String>(
                                    value: distance,
                                    child: Text(distance),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDistance = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitProfileStep1,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004D40),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                        ),
                      ],
                    );
                  } else if (state is ProfileError) {
                    return Text('Error: ${state.error}');
                  } else if (state is ProfileStep2Loaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Give us a brief description of your business',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _businessDescriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'How do you prefer us contacting you?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          title: const Text('Text Alert (SMS)'),
                          value: _textAlert,
                          onChanged: (bool value) {
                            setState(() {
                              _textAlert = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Email Alert'),
                          value: _emailAlert,
                          onChanged: (bool value) {
                            setState(() {
                              _emailAlert = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Love to get tips on how to get the right job?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SwitchListTile(
                          title: const Text('Subscribe to our newsletter'),
                          value: _newsletterSubscription,
                          onChanged: (bool value) {
                            setState(() {
                              _newsletterSubscription = value;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
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
                                  side: const BorderSide(
                                      color: Color(0xFF004D40)),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('Previous'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _submitProfileStep2();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const IDVerification()),
                                );
                              },
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
                        ),
                      ],
                    );
                  } else if (state is ProfileStep2Submitted) {
                    return const Text('Profile submission successful');
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main function to run the app
void main() {
  runApp(
    MaterialApp(
      title: 'Complete Profile',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(
        create: (context) =>
            ProfileBloc(useApi: false), // Set to true when API is ready
        child: const CompleteProfile2(),
      ),
    ),
  );
}
