// lib/bloc/quote_bloc.dart
import 'package:bloc/bloc.dart';
import '../models/quote.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(QuoteLoading()) {
    on<FetchQuotes>((event, emit) async {
      // Simulate a network request
      await Future.delayed(Duration(seconds: 2));
      try {
        // Replace with your data fetching logic
        final quotes = List.generate(
            10,
            (index) => Quote(
                  title: 'Small Chops',
                  location: 'Umuahia, Abia',
                  budget: 'Under NGN50,000',
                  postedDate: DateTime.parse('2024-05-23T11:22:45.000000Z'),
                ));
        emit(QuoteLoaded(quotes));
      } catch (e) {
        emit(QuoteError());
      }
    });
  }
}
