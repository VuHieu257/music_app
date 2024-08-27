import 'package:flutter/material.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../core/colors/color.dart';

class CareView extends StatelessWidget {
  final AnimationController animationController;

  const CareView({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final firstHalfAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final secondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final relaxFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final relaxSecondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-2, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _imageFirstHalfAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _imageSecondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-4, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _imageFirstHalfAnimation,
                child: SlideTransition(
                  position: _imageSecondHalfAnimation,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(image: AssetImage(
                          'assets/introduction_animation/care_image.png',
                        ),
                          fit: BoxFit.fitWidth,
                        )
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: relaxFirstHalfAnimation,
                child: SlideTransition(
                  position: relaxSecondHalfAnimation,
                  child: const Text(
                    "Spatial Dolby Atmos sound",
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold,color: Styles.light),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 64, right: 64, bottom: 16, top: 16),
                child: Text(
                  "Balanced Sound at different frequencies for true connoisseurs. Requires high speed internet",
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    color: Styles.light
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
