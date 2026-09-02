import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/pricing/domain/entities/estimate_revision.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';

enum EstimateRevisionsStatus { initial, loading, loaded, responding, failure }

class EstimateRevisionsState extends Equatable {
  final EstimateRevisionsStatus status;

  /// Newest first.
  final List<EstimateRevision> revisions;

  final String? error;

  const EstimateRevisionsState({
    this.status = EstimateRevisionsStatus.initial,
    this.revisions = const [],
    this.error,
  });

  EstimateRevision? get pending =>
      revisions.where((r) => r.awaitingPatient).firstOrNull;

  @override
  List<Object?> get props => [status, revisions, error];
}

/// Screen-scoped: the messaging feature creates one per thread and renders the
/// card. Pricing owns the record and the arithmetic; the bubble is theirs.
class EstimateRevisionCubit extends Cubit<EstimateRevisionsState> {
  final PricingRepository repository;
  final int careTaskId;

  EstimateRevisionCubit(this.repository, this.careTaskId)
      : super(const EstimateRevisionsState());

  Future<void> load() async {
    emit(const EstimateRevisionsState(status: EstimateRevisionsStatus.loading));

    final result = await repository.estimateRevisions(careTaskId);
    emit(result.fold(
      (failure) => EstimateRevisionsState(
        status: EstimateRevisionsStatus.failure,
        error: failure.message,
      ),
      (revisions) => EstimateRevisionsState(
        status: EstimateRevisionsStatus.loaded,
        revisions: revisions,
      ),
    ));
  }

  Future<void> approve(int revisionId) => _respond(revisionId, approve: true);

  Future<void> reject(int revisionId) => _respond(revisionId, approve: false);

  Future<void> _respond(int revisionId, {required bool approve}) async {
    if (state.status == EstimateRevisionsStatus.responding) return;
    emit(EstimateRevisionsState(
      status: EstimateRevisionsStatus.responding,
      revisions: state.revisions,
    ));

    final result =
        await repository.respondToRevision(revisionId, approve: approve);
    emit(result.fold(
      (failure) => EstimateRevisionsState(
        status: EstimateRevisionsStatus.loaded,
        revisions: state.revisions,
        error: failure.message,
      ),
      (updated) => EstimateRevisionsState(
        status: EstimateRevisionsStatus.loaded,
        revisions: [
          for (final revision in state.revisions)
            revision.id == updated.id ? updated : revision,
        ],
      ),
    ));
  }
}
