# Bob's bloc

A package that takes advantage of [BobsJobs](https://pub.dev/packages/bobs_jobs)
to radically simplify bloc applications.

![coverage][coverage_badge] [![pub package][pub_badge]][pub_link]
![style: very good analysis][very_good_analysis_badge]
![license: BSD 3][license_badge]

## 🕹️ Usage

```dart
// Define a your cubit state as a typedef.
typedef RandomNumberFetchState = BobsBlocState<RandomNumberFetchException, int>;

// Create your cubit with the BobsCubitMixin.
class RandomNumberFetchCubit extends Cubit<RandomNumberFetchState>
    with BobsCubitMixin {
  RandomNumberFetchCubit({required this.randomRepository}) : super(.initial());

  final RandomRepository randomRepository;

  // Make a request call and pass in your job. Everything else is handled for you.
  Future<void> fetchRandomNumber() =>
      request(randomRepository.fetchRandomNumber());
}

// ...

// Update your UI based on the current request state.
BlocBuilder<RandomNumberFetchCubit, RandomNumberFetchState>(
    builder: (context, state) => switch (state.status) {
        .initial => const Text('Generate a random number!'),
        .inProgress => const CircularProgressIndicator(),
        .succeeded => Text('${state.success}'),
        .failed => Text(
          switch (state.failure!) {
            .unknown => 'Unknown error occurred.',
            .overflow => 'Error: Overflowed',
          },
        ),
    },
),
```

### For more flexibility

```dart
// Extend BobsBlocState instead of using typedef.
class RandomNumberFetchState
    extends BobsBlocState<RandomNumberFetchException, int> {
  RandomNumberFetchState.initial() : super.initial();

  RandomNumberFetchState.inProgress() : super.inProgress();

  RandomNumberFetchState.completed(super.outcome) : super.completed();
}

class RandomNumberFetchCubit extends Cubit<RandomNumberFetchState> {
  RandomNumberFetchCubit({required this.randomRepository}) : super(.initial());

  final RandomRepository randomRepository;

  // Emit the state changes manually.
  Future<void> fetchRandomNumber() async {
    if (state.isInProgress) return;

    emit(.inProgress());

    final outcome = await randomRepository.fetchRandomNumber().run();

    emit(.completed(outcome));
  }
}
```

[coverage_badge]: https://raw.githubusercontent.com/VeryGoodOpenSource/very_good_cli/main/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-BSD3-blue.svg
[pub_badge]: https://img.shields.io/pub/v/bobs_bloc.svg
[pub_link]: https://pub.dartlang.org/packages/bobs_bloc
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
