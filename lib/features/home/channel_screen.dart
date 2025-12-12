import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:minimal_yt/data/youtube_repository.dart';
import 'package:minimal_yt/features/search/search_screen.dart'; // Kita pinjam widget VideoGridItem

// Provider khusus ambil video channel
final channelVideosProvider = FutureProvider.family<List<Video>, String>((ref, channelId) async {
  final repository = ref.watch(youtubeRepositoryProvider);
  return repository.getChannelVideos(channelId);
});

class ChannelScreen extends ConsumerWidget {
  final String channelName;
  final String channelId;

  const ChannelScreen({super.key, required this.channelName, required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVideos = ref.watch(channelVideosProvider(channelId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(channelName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: asyncVideos.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        data: (videos) {
          if (videos.isEmpty) return const Center(child: Text("No videos found.", style: TextStyle(color: Colors.grey)));
          
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              childAspectRatio: 16 / 11,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return VideoGridItem(video: videos[index]); // Reuse widget kartu yang lama
            },
          );
        },
      ),
    );
  }
}