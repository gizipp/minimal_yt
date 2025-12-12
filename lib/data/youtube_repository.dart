import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final youtubeRepositoryProvider = Provider((ref) => YoutubeRepository());

class YoutubeRepository {
  final _yt = YoutubeExplode();

  // 1. Search
  Future<List<Video>> searchVideos(String query) async {
    try {
      print("Searching for: $query");
      final searchList = await _yt.search.search(query);
      print("Found raw search results: ${searchList.length}");
      return _filterShorts(searchList);
    } catch (e) {
      print("Error searching: $e");
      return [];
    }
  }

  // 2. Channel Feed
  Future<List<Video>> getChannelVideos(String channelId) async {
    try {
      print("Fetching channel: $channelId");
      // Mengambil 20 video terbaru
      final uploads = await _yt.channels.getUploads(channelId).take(20).toList();
      print("Found raw channel videos: ${uploads.length}");
      return _filterShorts(uploads);
    } catch (e) {
      print("Error fetching channel: $e");
      return [];
    }
  }

  // LOGIC FILTER (DIPERBAIKI)
  List<Video> _filterShorts(Iterable<Video> videos) {
    final filtered = videos.where((video) {
      // Kalau durasi null/tidak terbaca, ANGGAP BUKAN SHORT (Loloskan)
      if (video.duration == null) return true;
      
      // Kalau ada durasi, baru cek apakah > 60 detik
      final isShort = video.duration!.inSeconds <= 60;
      return !isShort && !video.isLive;
    }).toList();

    print("After filtering shorts: ${filtered.length} videos remaining.");
    return filtered;
  }

  Future<String> getVideoUrl(String videoId) async {
    print("Getting URL for: $videoId");
    var manifest = await _yt.videos.streamsClient.getManifest(videoId);
    // Ambil MP4 dengan kualitas terbaik (720p/1080p)
    var streamInfo = manifest.muxed.withHighestBitrate();
    return streamInfo.url.toString();
  }
  
  void dispose() {
    _yt.close();
  }
}