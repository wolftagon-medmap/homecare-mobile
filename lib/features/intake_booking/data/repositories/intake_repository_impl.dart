import 'package:m2health/features/intake_booking/data/datasources/intake_remote_datasource.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/domain/repositories/intake_repository.dart';

class IntakeRepositoryImpl implements IntakeRepository {
  final IntakeRemoteDataSource _remote;

  IntakeRepositoryImpl(this._remote);

  @override
  Future<String> startSession() => _remote.startSession();

  @override
  Future<List<Block>> fetchHistory(String sessionId) =>
      _remote.fetchHistory(sessionId);

  @override
  Future<void> sendText({required String sessionId, required String text}) =>
      _remote.send(sessionId: sessionId, text: text);

  @override
  Future<void> sendReply(
          {required String sessionId, required String replyId}) =>
      _remote.send(sessionId: sessionId, replyId: replyId);

  @override
  Future<void> sendLocation({
    required String sessionId,
    required double lat,
    required double lng,
    required String address,
  }) =>
      _remote.send(
        sessionId: sessionId,
        location: {'lat': lat, 'lng': lng, 'address': address},
      );

  @override
  Stream<Block> streamBlocks(String sessionId, {int? lastEventId}) =>
      _remote.streamBlocks(sessionId, lastEventId: lastEventId);
}
