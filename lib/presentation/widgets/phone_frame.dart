import 'package:flutter/material.dart';

// ============================================================
// PHONE FRAME
// ============================================================
//
// Linux is a desktop platform, so Flutter normally gives us
// a desktop-sized application window.
//
// This widget creates a phone-like area in the middle.
//
// On a real Android/iPhone device, this widget would not
// be necessary.
//
// ============================================================

class PhoneFrame extends StatelessWidget {
  final Widget child;

  const PhoneFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8ED),

      body: Center(
        child: Container(
          width: 390,
          height: 844,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(36),

            border: Border.all(
              color: Colors.black,
              width: 3,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(33),

            child: child,
          ),
        ),
      ),
    );
  }
}