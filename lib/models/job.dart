import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String title;
  final String location;
  final String status;
  final DateTime postedDate;

  const Job({
    required this.title,
    required this.location,
    required this.status,
    required this.postedDate,
  });

  @override
  List<Object> get props => [title, location, status, postedDate];
}
