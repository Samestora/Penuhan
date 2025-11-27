import 'package:flutter/material.dart';
import 'package:penuhan/features/app/screens/title_screen.dart';
import 'package:penuhan/core/utils/asset_manager.dart';

/// Fade in -> 2 seconds
/// NECESSARY jank for 0.05 seconds
/// Fade out -> 2 seconds

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void>? _precacheFuture;
  double _opacity = 0.0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1.0; // Trigger fade-in
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheFuture ??= _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      precacheCoreAssets(context),
      Future.delayed(const Duration(seconds: 2)),
    ]);
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TitleScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _precacheFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !_isLoaded) {
          _isLoaded = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _opacity = 0.0; // Trigger fade-out
            });
          });
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 1500),
                  onEnd: () {
                    if (_isLoaded) {
                      _navigateToNextScreen();
                    }
                  },
                  child: Column(
                    children: [Image.asset(AssetManager.splashLogo)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
