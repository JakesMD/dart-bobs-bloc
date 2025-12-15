import 'package:bobs_bloc/bobs_bloc.dart';
import 'package:example/random_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef RandomNumberFetchState =
    BobsRequestCubitState<RandomNumberFetchException, int>;

class RandomNumberFetchCubit extends Cubit<RandomNumberFetchState>
    with BobsRequestCubitMixin {
  RandomNumberFetchCubit({required this.randomRepository}) : super(.initial());

  final RandomRepository randomRepository;

  Future<void> fetchRandomNumber() =>
      request(randomRepository.fetchRandomNumber());
}
