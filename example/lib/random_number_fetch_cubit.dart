import 'package:bobs_bloc/bobs_bloc.dart';
import 'package:example/random_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BRandomNumberFetchState =
    BobsRequestCubitState<RandomNumberFetchException, int>;

class BRandomNumberFetchCubit extends Cubit<BRandomNumberFetchState>
    with BBobsRequestCubitMixin {
  BRandomNumberFetchCubit({required this.randomRepository}) : super(.initial());

  final RandomRepository randomRepository;

  Future<void> fetchRandomNumber() =>
      request(randomRepository.fetchRandomNumber());
}
