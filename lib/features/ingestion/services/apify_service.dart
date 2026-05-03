import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';

class ApifyService {
  const ApifyService({required String apiKey}) : _apiKey = apiKey;
  final String _apiKey;

  static const _baseUrl = 'https://api.apify.com/v2/acts';
  static const _instagramActor = 'apify~instagram-scraper';
  static const _facebookActor = 'apify~facebook-posts-scraper';

  /// Returns the caption/text of the post at [url].
  /// Throws [IngestionException] on any failure.
  Future<String> fetchCaption(String url) async {
    final host = Uri.parse(url).host.toLowerCase();
    if (host.contains('instagram.com')) return _fetchInstagram(url);
    if (host.contains('facebook.com') ||
        host.contains('fb.com') ||
        host.contains('fb.watch')) {
      return _fetchFacebook(url);
    }
    throw const IngestionException(
        'כתובת URL לא נתמכת. Apify תומך בפייסבוק ואינסטגרם בלבד.');
  }

  Future<String> _fetchInstagram(String url) async {
    AppLogger.d('ApifyService: Instagram → $url');
    final response = await http
        .post(
          Uri.parse(
              '$_baseUrl/$_instagramActor/run-sync-get-dataset-items?token=$_apiKey&timeout=120'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {'directUrls': [url], 'resultsType': 'posts', 'resultsLimit': 1}),
        )
        .timeout(const Duration(seconds: 130));

    _checkStatus(response);
    final items = jsonDecode(response.body) as List<dynamic>;
    if (items.isEmpty) {
      throw const IngestionException(
          'Apify לא הצליח לאחזר את הפוסט מאינסטגרם. ודא שהפוסט ציבורי.');
    }
    final caption =
        (items.first as Map<String, dynamic>)['caption'] as String? ?? '';
    if (caption.trim().isEmpty) {
      throw const IngestionException('לא נמצא כיתוב בפוסט זה.');
    }
    return caption.trim();
  }

  Future<String> _fetchFacebook(String url) async {
    AppLogger.d('ApifyService: Facebook → $url');
    final response = await http
        .post(
          Uri.parse(
              '$_baseUrl/$_facebookActor/run-sync-get-dataset-items?token=$_apiKey&timeout=120'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'startUrls': [
              {'url': url}
            ],
            'maxPosts': 1,
          }),
        )
        .timeout(const Duration(seconds: 130));

    _checkStatus(response);
    final items = jsonDecode(response.body) as List<dynamic>;
    if (items.isEmpty) {
      throw const IngestionException(
          'Apify לא הצליח לאחזר את הפוסט מפייסבוק. ודא שהפוסט ציבורי.');
    }
    final text =
        (items.first as Map<String, dynamic>)['text'] as String? ?? '';
    if (text.trim().isEmpty) {
      throw const IngestionException('לא נמצא תוכן בפוסט זה.');
    }
    return text.trim();
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode == 401) {
      throw const IngestionException(
          'מפתח Apify אינו תקין. עדכן אותו בהגדרות.');
    }
    if (response.statusCode == 402) {
      throw const IngestionException(
          'חשבון Apify ללא קרדיט מספיק. בדוק את חשבונך.');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw IngestionException(
          'שגיאת Apify (קוד ${response.statusCode}). נסה שוב מאוחר יותר.');
    }
  }
}
