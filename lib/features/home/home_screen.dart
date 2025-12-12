import 'package:flutter/material.dart';
import 'package:minimal_yt/core/channel_config.dart';
import 'package:minimal_yt/features/search/search_screen.dart';
import 'package:minimal_yt/features/home/channel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Fokus awal tetap ke Search Bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocus);
    });
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(query: query)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 700, // Lebarin dikit
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo & Judul
              const Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
              const SizedBox(height: 10),
              const Text("Minimal YT", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1.5)),
              const SizedBox(height: 30),
              
              // 2. SEARCH BAR
              TextField(
                controller: _controller,
                focusNode: _searchFocus,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search intentionally...",
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _submitSearch,
              ),

              const SizedBox(height: 40),
              
              // 3. DAFTAR CHANNEL (FEED CONFIG)
              const Text("QUICK ACCESS", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
              const SizedBox(height: 20),
              
              SizedBox(
                height: 120, // Tinggi area tombol
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true, // Supaya ke tengah
                  itemCount: ChannelConfig.pinnedChannels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final channel = ChannelConfig.pinnedChannels[index];
                    return ChannelButton(
                      name: channel['name']!,
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ChannelScreen(
                              channelName: channel['name']!,
                              channelId: channel['id']!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Tombol Channel (Bulat)
class ChannelButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  const ChannelButton({super.key, required this.name, required this.onTap});

  @override
  State<ChannelButton> createState() => _ChannelButtonState();
}

class _ChannelButtonState extends State<ChannelButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onFocusChange: (val) => setState(() => _isFocused = val),
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : Colors.grey[900], // Jadi putih kalau dipilih
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isFocused ? Colors.white : Colors.grey[800]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tv, color: _isFocused ? Colors.black : Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: _isFocused ? Colors.black : Colors.white, // Text jadi hitam kalau background putih
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}