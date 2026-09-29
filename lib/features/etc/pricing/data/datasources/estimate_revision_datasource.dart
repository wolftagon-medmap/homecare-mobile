import 'package:m2health/features/etc/pricing/data/datasources/pricing_endpoint_client.dart';
import 'package:m2health/features/etc/pricing/data/models/estimate_revision_model.dart';

abstract class EstimateRevisionDataSource {
  Future<List<EstimateRevisionModel>> forCareTask(int careTaskId);

  Future<EstimateRevisionModel> approve(int revisionId);

  Future<EstimateRevisionModel> reject(int revisionId);
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
