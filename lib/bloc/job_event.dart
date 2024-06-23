// lib/bloc/job_event.dart
import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

class FetchJobs extends JobEvent {}
