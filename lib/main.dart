import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Import halaman Home (nanti kita buat isinya)
import 'features/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MinimalYTApp()));
}

class MinimalYTApp extends StatelessWidget {
  const MinimalYTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      // Mapping tombol "Select/OK" di Remote TV agar berfungsi seperti "Enter"
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        title: 'Minimal YT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark, // Tema Gelap Wajib
          scaffoldBackgroundColor: Colors.black, // Hitam pekat OLED
          primaryColor: Colors.white,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme.apply(bodyColor: Colors.white),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}