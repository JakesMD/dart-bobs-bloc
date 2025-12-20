import 'package:bobs_bloc/bobs_bloc.dart';
import 'package:bobs_jobs/bobs_jobs.dart';

/// {@template BobsBlocState}
///
/// A state class for managing the status and outcome of a request in a bloc or
/// cubit.
///
/// It holds the [outcome] of the request, which can be either a failure of type
/// [F] or a success of type [S], and the current [status] of the request.
///
/// Provides convenience getters to check the state of the request and to access
/// the failure or success values.
///
/// {@endtemplate}
class BobsBlocState<F, S> {
  /// {@macro BobsBlocState}
  BobsBlocState({required this.outcome, required this.status});

  /// {@macro BobsBlocState}
  ///
  /// The initial state. It sets [status] to [BobsBlocStatus.initial].
  BobsBlocState.initial([this.outcome]) : status = BobsBlocStatus.initial;

  /// {@macro BobsBlocState}
  ///
  /// The in progress state. It sets [status] to [BobsBlocStatus.inProgress].
  BobsBlocState.inProgress([this.outcome]) : status = BobsBlocStatus.inProgress;

  /// {@macro BobsBlocState}
  ///
  /// The completed state. It sets [status] to [BobsBlocStatus.failed] or
  /// [BobsBlocStatus.succeeded] based on the outcome.
  BobsBlocState.completed(BobsOutcome<F, S> this.outcome)
    : status = outcome.succeeded
          ? BobsBlocStatus.succeeded
          : BobsBlocStatus.failed;

  /// The outcome of the request if completed.
  final BobsOutcome<F, S>? outcome;

  /// The status of the request.
  final BobsBlocStatus status;

  /// The failure value of the request. Returns null if the request has not
  /// failed.
  F? get failure =>
      outcome?.resolve(onFailure: (error) => error, onSuccess: (_) => null);

  /// The success value of the request. Returns null if the request has not
  /// succeeded.
  S? get success =>
      outcome?.resolve(onFailure: (_) => null, onSuccess: (value) => value);

  /// Returns true if the request has not yet been made.
  bool get isInitial => status == BobsBlocStatus.initial;

  /// Returns true if the request is in progress.
  bool get isInProgress => status == BobsBlocStatus.inProgress;

  /// Returns true if the request succeeded.
  bool get succeeded => status == BobsBlocStatus.succeeded;

  /// Returns true if the request failed.
  bool get failed => status == BobsBlocStatus.failed;

  @override
  String toString() => switch (status) {
    .initial => 'BobsBlocState<$F, $S>.initial()',
    .inProgress => 'BobsBlocState<$F, $S>.inProgress()',
    .failed => 'BobsBlocState<$F, $S>.failed($failure)',
    .succeeded => 'BobsBlocState<$F, $S>.succeeded($success)',
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BobsBlocState<F, S> &&
          runtimeType == other.runtimeType &&
          outcome == other.outcome &&
          status == other.status;

  @override
  int get hashCode => runtimeType.hashCode ^ outcome.hashCode ^ status.hashCode;
}
