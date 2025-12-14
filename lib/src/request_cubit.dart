import 'package:bloc/bloc.dart';
import 'package:bobs_jobs/bobs_jobs.dart';

/// The status of the [BobsRequestCubitState].
enum BobsRequestCubitStatus {
  /// No request has been made yet.
  initial,

  /// The request is currently in progress.
  inProgress,

  /// The request failed.
  failed,

  /// The request succeeded.
  succeeded,
}

/// {@template BobsRequestCubitState}
///
/// A state class for managing the status and outcome of a request in a Cubit.
///
/// It holds the [outcome] of the request, which can be either a failure of type
/// [F] or a success of type [S], and the current [status] of the request.
///
/// Provides convenience getters to check the state of the request and to access
/// the failure or success values.
///
/// {@endtemplate}
class BobsRequestCubitState<F, S> {
  /// {@macro BobsRequestCubitState}
  BobsRequestCubitState({required this.outcome, required this.status});

  /// {@macro BobsRequestCubitState}
  ///
  /// The initial state. It sets [status] to
  /// [BobsRequestCubitStatus.initial].
  BobsRequestCubitState.initial([this.outcome])
    : status = BobsRequestCubitStatus.initial;

  /// {@macro BobsRequestCubitState}
  ///
  /// The in progress state. It sets [status] to
  /// [BobsRequestCubitStatus.inProgress].
  BobsRequestCubitState.inProgress([this.outcome])
    : status = BobsRequestCubitStatus.inProgress;

  /// {@macro BobsRequestCubitState}
  ///
  /// The completed state. It sets [status] to [BobsRequestCubitStatus.failed]
  /// or [BobsRequestCubitStatus.succeeded] based on the outcome.
  BobsRequestCubitState.completed(BobsOutcome<F, S> this.outcome)
    : status = outcome.succeeded
          ? BobsRequestCubitStatus.succeeded
          : BobsRequestCubitStatus.failed;

  /// The outcome of the request if completed.
  final BobsOutcome<F, S>? outcome;

  /// The status of the request.
  final BobsRequestCubitStatus status;

  /// The failure value of the request. Returns null if the request has not
  /// failed.
  F? get failure =>
      outcome?.resolve(onFailure: (error) => error, onSuccess: (_) => null);

  /// The success value of the request. Returns null if the request has not
  /// succeeded.
  S? get success =>
      outcome?.resolve(onFailure: (_) => null, onSuccess: (value) => value);

  /// Returns true if the request has not yet been made.
  bool get isInitial => status == BobsRequestCubitStatus.initial;

  /// Returns true if the request is in progress.
  bool get isInProgress => status == BobsRequestCubitStatus.inProgress;

  /// Returns true if the request succeeded.
  bool get succeeded => status == BobsRequestCubitStatus.succeeded;

  /// Returns true if the request failed.
  bool get failed => status == BobsRequestCubitStatus.failed;

  @override
  String toString() => switch (status) {
    .initial => 'initial()',
    .inProgress => 'inProgress()',
    .failed => 'failed($failure)',
    .succeeded => 'succeeded($success)',
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BobsRequestCubitState<F, S> &&
          runtimeType == other.runtimeType &&
          outcome == other.outcome &&
          status == other.status;

  @override
  int get hashCode => runtimeType.hashCode ^ outcome.hashCode ^ status.hashCode;
}

/// A mixin that adds request handling capabilities to a Cubit using
/// [BobsRequestCubitState].
mixin BBobsRequestCubitMixin<F, S> on Cubit<BobsRequestCubitState<F, S>> {
  /// Performs a request using the provided [job] and updates the Cubit's state
  /// accordingly.
  ///
  /// If a request is already in progress, this method returns immediately
  /// without making a new request.
  Future<void> request(BobsJob<F, S> job) async {
    if (state.isInProgress) return;
    emit(.inProgress(state.outcome));
    emit(.completed(await job.run()));
  }
}
