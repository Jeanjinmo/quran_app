import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/api_response_model.dart';
import '../models/surah_model.dart';

/// Fetches data from the Al-Quran Cloud API over Dio. HTTP/JSON only —
/// throws on failure; the repository maps exceptions to typed [Failure]s.
abstract interface class QuranRemoteDataSource {
  /// Fetches all 114 surahs. Throws [ServerException] on a bad response and lets
  /// [DioException] propagate for the repository to classify.
  Future<List<SurahModel>> getSurahList();
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  const QuranRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<SurahModel>> getSurahList() async {
    final response = await _dio.get<Object?>(ApiConstants.surahList);
    final envelope = ApiResponseModel.fromJson(
      response.data,
      SurahModel.listFromData,
    );
    return envelope.data;
  }
}
