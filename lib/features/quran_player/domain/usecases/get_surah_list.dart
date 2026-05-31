import '../../../../core/utils/result.dart';
import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

/// Fetches all 114 surahs from the repository.
class GetSurahList {
  const GetSurahList(this._repository);

  final QuranRepository _repository;

  Future<Result<List<Surah>>> call() => _repository.getSurahList();
}
