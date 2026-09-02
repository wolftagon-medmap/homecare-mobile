import 'package:m2health/features/pricing/data/datasources/pricing_endpoint_client.dart';
import 'package:m2health/features/pricing/data/fixtures/estimate_revision_fixture.dart';
import 'package:m2health/features/pricing/data/models/estimate_revision_model.dart';

abstract class EstimateRevisionDataSource {
  Future<List<EstimateRevisionModel>> forCareTask(int careTaskId);

  Future<EstimateRevisionModel> approve(int revisionId);

  Future<EstimateRevisionModel> reject(int revisionId);
}

class EstimateRevisionLocalDataSource implements EstimateRevisionDataSource {
  EstimateRevisionLocalDataSource();

  /// Answers survive the session so the demo can approve and come back.
  final Map<int, String> _answers = {};

  @override
  Future<List<EstimateRevisionModel>> forCareTask(int careTaskId) async {
    final rows = kEstimateRevisionFixture[careTaskId] ?? const [];
    return rows.map(_parse).toList();
  }

  @override
  Future<EstimateRevisionModel> approve(int revisionId) =>
      _respond(revisionId, 'approved');

  @override
  Future<EstimateRevisionModel> reject(int revisionId) =>
      _respond(revisionId, 'rejected');

  Future<EstimateRevisionModel> _respond(int revisionId, String status) async {
    _answers[revisionId] = status;

    for (final rows in kEstimateRevisionFixture.values) {
      for (final row in rows) {
        if (row['id'] == revisionId) return _parse(row);
      }
    }
    throw StateError('no fixture revision $revisionId');
  }

  EstimateRevisionModel _parse(Map<String, dynamic> row) {
    final answered = _answers[row['id']];
    return EstimateRevisionModel.fromJson({
      ...row,
      if (answered != null) 'status': answered,
      if (answered != null) 'responded_at': DateTime.now().toIso8601String(),
    });
  }
}

class EstimateRevisionRemoteDataSource extends PricingEndpointClient
    implements EstimateRevisionDataSource {
  EstimateRevisionRemoteDataSource({required super.dio});

  @override
  Future<List<EstimateRevisionModel>> forCareTask(int careTaskId) =>
      guard('load the revised estimate', () async {
        final response = await dio.get<dynamic>(
          url('/care-tasks/$careTaskId/estimate-revisions'),
          options: await authHeaders(),
        );
        return unwrapList(response.data)
            .map(EstimateRevisionModel.fromJson)
            .toList();
      });

  @override
  Future<EstimateRevisionModel> approve(int revisionId) =>
      _respond(revisionId, 'approve', 'approve the revised estimate');

  @override
  Future<EstimateRevisionModel> reject(int revisionId) =>
      _respond(revisionId, 'reject', 'decline the revised estimate');

  Future<EstimateRevisionModel> _respond(
    int revisionId,
    String action,
    String label,
  ) =>
      guard(label, () async {
        final response = await dio.post<dynamic>(
          url('/estimate-revisions/$revisionId/$action'),
          options: await authHeaders(),
        );
        return EstimateRevisionModel.fromJson(unwrap(response.data));
      });
}
