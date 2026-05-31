import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/edition.dart';
import '../../domain/entities/playback_snapshot.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/player_local_data_source.dart';
import '../datasources/quran_remote_data_source.dart';

/// Concrete implementation of [QuranRepository] managing API requests, local
/// storage, and local offline reciters allowlist.
///
/// Connectivity is checked before remote operations to surface connection
/// issues immediately.
class QuranRepositoryImpl implements QuranRepository {
  const QuranRepositoryImpl(this._remote, this._local, this._networkInfo);

  final QuranRemoteDataSource _remote;
  final PlayerLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<List<Surah>>> getSurahList() async {
    if (!await _networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final models = await _remote.getSurahList();
      return Ok(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Err(ServerFailure(e.message));
    } on DioException catch (e) {
      return Err(ServerFailure(e.message ?? 'Network request failed'));
    }
  }

  /// The reciter list is a curated, offline constant — no network needed. This
  /// is intentional: the live `/edition` ids don't match the CDN's full-surah
  /// namespace, so we map our verified allowlist directly to entities.
  @override
  Future<Result<List<Edition>>> getAudioEditions() async {
    final editions = QariConstants.allowlist
        .map(
          (q) => Edition(id: q.cdnId, name: q.name, arabicName: q.arabicName),
        )
        .toList();
    return Ok(editions);
  }

  @override
  Result<PlaybackSnapshot?> getLastPlayed() {
    try {
      return Ok(_local.readLastPlayed());
    } on CacheException catch (e) {
      return Err(CacheFailure(e.message));
    }
  }

  @override
  Future<Result<void>> saveLastPlayed(PlaybackSnapshot snapshot) async {
    try {
      await _local.saveLastPlayed(snapshot);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(e.message));
    }
  }
}
