import 'dart:math';

import 'package:bobs_jobs/bobs_jobs.dart';

enum RandomNumberFetchException { unknown, overflow }

class RandomRepository {
  BobsJob<RandomNumberFetchException, int> fetchRandomNumber() =>
      BobsJob.attempt(
        run: () {
          return Future<int>.delayed(
            const Duration(milliseconds: 1000),
            () => Random().nextInt(20),
          );
        },
        onError: (_) => RandomNumberFetchException.unknown,
      ).thenValidateSuccess(
        isValid: (value) => value < 10,
        onInvalid: (_) => RandomNumberFetchException.overflow,
      );
}
