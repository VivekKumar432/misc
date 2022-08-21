import 'package:http/http.dart' as http;

// API Call (Itunes)
class SongClient {
  static Future<http.Response> getSongsBySingerName(String singerName) {
    final String URL =
        "https://itunes.apple.com/search?term=$singerName&limit=25";
    Future<http.Response> future = http.get(Uri.parse(URL));
    return future;
    // Here i do a network call
    // network calls are slow
    // Async (Non Blocking Call) + Future
  }
}
