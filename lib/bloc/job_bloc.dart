// lib/bloc/job_bloc.dart
import 'package:bloc/bloc.dart';
import '../models/job.dart';
import 'job_event.dart';
import 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc() : super(JobLoading()) {
    on<FetchJobs>((event, emit) async {
      // Simulate a network request
      await Future.delayed(Duration(seconds: 2));
      try {
        // Use the provided job titles
        final jobs = [
          Job(
            title: 'Aluminium Maker',
            location: 'Lagos',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Auto Mechanic',
            location: 'Abuja',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Builder',
            location: 'Port Harcourt',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Carpenter',
            location: 'Enugu',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Computer Repairer',
            location: 'Kaduna',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Drainage Specialist',
            location: 'Ibadan',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Draughtsman',
            location: 'Abeokuta',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Driver',
            location: 'Benin',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Electrician',
            location: 'Kano',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Event Planner & Caterers',
            location: 'Calabar',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Fashion Designer',
            location: 'Jos',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Gardener',
            location: 'Owerri',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Gas Cooker Repairer',
            location: 'Asaba',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Generator Repairer',
            location: 'Uyo',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Hair Stylist',
            location: 'Makurdi',
            status: 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
          Job(
            title: 'Home Maintenance/ Repair',
            location: 'Ilorin',
            status: 'Job Completed',
            postedDate: DateTime.now(),
          ),
        ];
        emit(JobLoaded(jobs));
      } catch (e) {
        emit(JobError());
      }
    });
  }
}
