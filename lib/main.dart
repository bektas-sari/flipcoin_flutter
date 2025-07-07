import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  const CoinFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yazı Tura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const CoinFlipPage(),
    );
  }
}

class CoinFlipPage extends StatefulWidget {
  const CoinFlipPage({super.key});

  @override
  State<CoinFlipPage> createState() => _CoinFlipPageState();
}

class _CoinFlipPageState extends State<CoinFlipPage> with SingleTickerProviderStateMixin {
  int yazi = 0;
  int tura = 0;
  String sonuc = "";
  bool isFlipping = false;
  String currentSide = 'yazi';

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 10 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => isFlipping = false);
      }
    });
  }

  void flipCoin() {
    if (isFlipping) return;

    setState(() {
      isFlipping = true;
      sonuc = "";
    });

    _controller.reset();
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      final isTura = Random().nextBool();
      setState(() {
        currentSide = isTura ? 'tura' : 'yazi';
        if (isTura) {
          tura++;
          sonuc = "TURA!";
        } else {
          yazi++;
          sonuc = "YAZI!";
        }
      });
    });
  }

  void reset() {
    setState(() {
      yazi = 0;
      tura = 0;
      sonuc = "";
      currentSide = 'yazi';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6a11cb), Color(0xff2575fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              children: [
                Text(
                  '🪙 YAZI TURA',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Parayı döndür, sonucu öğren!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // Animasyonlu Para
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(_animation.value),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/$currentSide.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                AnimatedOpacity(
                  opacity: sonuc.isEmpty ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    sonuc,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Spacer(),

                // Skor kutuları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreBox("YAZI", yazi),
                    _buildScoreBox("TURA", tura),
                  ],
                ),

                const SizedBox(height: 30),

                // Parayı At butonu
                ElevatedButton.icon(
                  onPressed: flipCoin,
                  icon: const Icon(Icons.sync),
                  label: const Text("PARAYI AT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text("SIFIRLA"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBox(String label, int count) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            "$count",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
