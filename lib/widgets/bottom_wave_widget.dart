import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class BottomWaveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
            config: CustomConfig(
              gradients: [
                [Color(0xFFd7d9f2), Color(0xFFd7d9f2)],
                [Color(0xFFa69aee), Color(0xFFa69aee)],
                [Color(0xFF816fe7), Color(0xFF816fe7)],
              ],
              durations: [14000, 20000, 25000],
              heightPercentages: [0.30, 0.20,0.25],
              blur: MaskFilter.blur(BlurStyle.solid, 2),
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            waveAmplitude: 20,
            size: Size(double.infinity, 150),
          );
  }
}