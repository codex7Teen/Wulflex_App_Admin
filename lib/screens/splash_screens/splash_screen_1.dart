import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/screens/authentication_screens/login_screen.dart';
import 'package:wulflex_admin/screens/main_screens/home_screen.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenSplash1 extends StatefulWidget {
  const ScreenSplash1({super.key});

  @override
  State<ScreenSplash1> createState() => _ScreenSplash12State();
}

class _ScreenSplash12State extends State<ScreenSplash1> {
  bool _animateTextLogo = false;
  bool _animateLogo = false;

  @override
  void initState() {
    super.initState();

    // Delay for 1 second before triggering the animations
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _animateLogo = true;
        });

        // After triggering the logo animation, delay for the text logo animation
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _animateTextLogo = true;
            });
          }
        });
      }
    });

    // Navigate to login after some seconds
    _checkLoginStatus();
  }

  //! Method to check login status using sharedpreferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Future.delayed(
        Duration(seconds: 4),
        () {
          if (mounted) {
            NavigationHelper.navigateToWithReplacement(context, ScreenHome(),
                milliseconds: 600);
          }
        },
      );
    } else {
      Future.delayed(
        Duration(seconds: 4),
        () {
          if (mounted) {
            NavigationHelper.navigateToWithReplacement(context, ScreenLogin(),
                milliseconds: 600);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffoldColor,
      body: Center(
        child: ClipRect(
          child: SizedBox(
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Wulflex text that moves from right to center (background) with opacity animation
                AnimatedPositioned(
                  duration: Duration(milliseconds: 800),
                  left: _animateTextLogo ? 80 : 0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 800),
                    opacity: _animateTextLogo ? 1.0 : 0.0,
                    child: Image.asset(
                      'assets/wulflex_text_nobg.png',
                      width: 135,
                    ),
                  ),
                ),
                // Logo that stays centered initially, then moves slightly left (foreground)
                AnimatedPositioned(
                  duration: Duration(milliseconds: 800),
                  left: _animateLogo ? -77 : 0,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 75,
                          height: 75,
                          child:
                              ColoredBox(color: AppColors.lightScaffoldColor)),
                      Image.asset(
                        'assets/wulflex_logo_white_bg.jpg',
                        width: 75,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
