class ChannelConfig {
  // Masukkan Channel ID di sini.
  // Cara cari ID: Buka channel di browser, lihat URL-nya (youtube.com/channel/UC.....)
  
  static const List<Map<String, String>> pinnedChannels = [
    {
      'name': 'Bluey',
      'id': 'UCVzLLZkDuFGAE2BGdBuBNBg', // Official Bluey Channel ID
      'iconAsset': 'assets/bluey_icon.png', // Nanti bisa pakai Icon biasa kalau belum ada gambar
    },
    {
      'name': 'Super Simple Songs',
      'id': 'UCLsooMJoIpl_7ux2jvdPB-Q', // Super Simple Songs ID
    },
    // Tambah lagi sesuka hati sebelum build APK
    {
      'name': 'boboring club',
      'id': 'UCCfvJD93UsJ3J5MG8ffR9nA', 
    },
  ];
}