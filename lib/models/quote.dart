import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String title;
  final String location;
  final String budget;
  final DateTime postedDate;

  const Quote({
    required this.title,
    required this.location,
    required this.budget,
    required this.postedDate,
  });

  @override
  List<Object> get props => [title, location, budget, postedDate];
}
