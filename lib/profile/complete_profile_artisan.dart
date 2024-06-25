import 'package:check_artisan/profile/complete_profile_artisan2.dart';
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

class SubmitProfile extends ProfileEvent {
  final String businessName;
  final String location;
  final String tradeType;
  final List<String> skills;
  final String country;
  final String state;
  final String city;
  final String distance;

  const SubmitProfile({
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

class ProfileSubmitted extends ProfileState {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final bool useApi;

  ProfileBloc({this.useApi = false}) : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<SubmitProfile>(_onSubmitProfile);
  }

  Future<void> _onLoadProfileData(
      LoadProfileData event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response = await http.get(Uri.parse(''));

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

  Future<void> _onSubmitProfile(
      SubmitProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''),
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
          emit(ProfileSubmitted());
        } else {
          emit(const ProfileError('Failed to submit data'));
        }
      } else {
        // Simulate successful submission
        await Future.delayed(const Duration(seconds: 1));
        emit(ProfileSubmitted());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  CompleteProfileState createState() => CompleteProfileState();
}

class CompleteProfileState extends State<CompleteProfile> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedTradeType;
  final List<String> _selectedSkills = [];
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedDistance;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  void _submitProfile() {
    context.read<ProfileBloc>().add(
          SubmitProfile(
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
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Business name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ProfileLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            onPressed: () {
                              _submitProfile();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompleteProfile2(),
                                ),
                              );
                            },
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
