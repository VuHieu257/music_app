import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import '../../core/colors/color.dart';

class CusButton extends StatelessWidget {
  final String text;
  final Color color;
  const CusButton({super.key,required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: context.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: Styles.defaultBorderRadius,
          color: color
      ),
      child: Text(
        text,
        style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Styles.light
        ),
      ),
    );
  }
}
