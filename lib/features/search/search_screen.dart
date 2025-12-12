import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:minimal_yt/data/youtube_repository.dart';
import 'package:minimal_yt/features/player/player_screen.dart';

// 1. PROVIDER: Ini "kurir" yang minta data ke Repository berdasarkan query
final searchVideosProvider = FutureProvider.family<List<Video>, String>((ref, query) async {
  final repository = ref.watch(youtubeRepositoryProvider);
  return repository.searchVideos(query);
});

class SearchScreen extends ConsumerWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memantau status data (Loading, Error, atau Ada Data)
    final asyncVideos = ref.watch(searchVideosProvider(query));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Results: "$query"', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: asyncVideos.when(
        // KONDISI 1: Loading
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        
        // KONDISI 2: Error
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        
        // KONDISI 3: Data Tersedia
        data: (videos) {
          if (videos.isEmpty) {
            return const Center(child: Text("No intentional content found.", style: TextStyle(color: Colors.grey)));
          }
          
          // Tampilkan Grid Video
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 Video per baris (pas untuk TV)
              childAspectRatio: 16 / 11, // Rasio kartu video
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return VideoGridItem(video: video);
            },
          );
        },
      ),
    );
  }
}

// WIDGET KARTU VIDEO (Dipecah biar rapi)
class VideoGridItem extends StatefulWidget {
  final Video video;
  const VideoGridItem({super.key, required this.video});

  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  // Variable untuk tahu apakah kartu ini sedang dipilih remote atau tidak
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Fungsi Focus Android TV
      onFocusChange: (value) {
        setState(() {
          _isFocused = value;
        });
      },
      onTap: () {
        // Navigasi ke Player
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(videoId: widget.video.id.value),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Efek Visual: Kalau dipilih remote, dia membesar sedikit & border putih
        transform: _isFocused ? Matrix4.identity().scaled(1.05) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _isFocused ? Colors.grey[900] : Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: _isFocused ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  widget.video.thumbnails.mediumResUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => 
                    Container(color: Colors.grey[800], child: const Icon(Icons.error)),
                ),
              ),
            ),
            // Judul & Metadata
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _isFocused ? Colors.black : Colors.white, // Invert warna text kalau fokus
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.video.author} • ${widget.video.duration?.inMinutes ?? 0} min",
                    style: TextStyle(
                      color: _isFocused ? Colors.black54 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}