import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DesignStatusBar extends StatelessWidget {
  const DesignStatusBar({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '9:41',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const Spacer(),
        SvgPicture.asset(assetPath, width: 69, height: 13, fit: BoxFit.contain),
      ],
    );
  }
}
