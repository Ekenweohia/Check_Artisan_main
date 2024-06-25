import 'package:equatable/equatable.dart';
import '../models/quote.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final List<Quote> quotes;

  const QuoteLoaded(this.quotes);

  @override
  List<Object> get props => [quotes];
}

class QuoteError extends QuoteState {}
