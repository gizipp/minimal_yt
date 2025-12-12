import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_yt/data/youtube_repository.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String videoId;
  const PlayerScreen({super.key, required this.videoId});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showControls = false; // Overlay control (Play/Pause)
  FocusNode _playPauseFocus = FocusNode(); // Fokus untuk tombol play

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // 1. Ambil URL video asli dari Repository
      final repository = ref.read(youtubeRepositoryProvider);
      final videoUrl = await repository.getVideoUrl(widget.videoId);

      // 2. Siapkan Video Player
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller!.initialize();
      
      // 3. Mulai Putar & Update UI
      setState(() {
        _isLoading = false;
      });
      _controller!.play();
      
      // Request fokus ke tombol Play/Pause supaya remote langsung aktif
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(_playPauseFocus);
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error playing video: $e";
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _playPauseFocus.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _showControls = true; // Munculkan icon pause
      } else {
        _controller!.play();
        _showControls = true;
        // Hilangkan icon play setelah 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _controller!.value.isPlaying) {
            setState(() => _showControls = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // LAYER 1: VIDEO
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : _errorMessage != null
                    ? Text(_errorMessage!, style: const TextStyle(color: Colors.red))
                    : AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
          ),

          // LAYER 2: CONTROLS (INVISIBLE BUT FOCUSABLE)
          // Kita pakai InkWell besar di tengah layar untuk menangkap klik Remote
          if (!_isLoading && _errorMessage == null)
            Positioned.fill(
              child: InkWell(
                focusNode: _playPauseFocus,
                onTap: _togglePlayPause,
                // Saat fokus (di-highlight remote), jangan ubah warna video
                focusColor: Colors.transparent, 
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(), // Container kosong transparan
              ),
            ),

          // LAYER 3: ICON OVERLAY (Play/Pause Icon)
          if (!_isLoading && _errorMessage == null && (_showControls || !_controller!.value.isPlaying))
            IgnorePointer(
              child: Container(
                color: Colors.black45, // Gelapkan sedikit background
                child: Center(
                  child: Icon(
                    _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
            ),
            
          // LAYER 4: Back Button Hint (Optional)
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const BackButton(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}