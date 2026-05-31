import '../../../../core/utils/result.dart';
import '../entities/edition.dart';
import '../repositories/quran_repository.dart';

/// Fetches the curated, playable reciter list ("artists").
class GetAudioEditions {
  const GetAudioEditions(this._repository);

  final QuranRepository _repository;

  Future<Result<List<Edition>>> call() => _repository.getAudioEditions();
}
