import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomLinearProgress extends ConsumerStatefulWidget {
  const BottomLinearProgress({super.key});

  @override
  _BottomLinearProgressState createState() => _BottomLinearProgressState();
}

class _BottomLinearProgressState extends ConsumerState<BottomLinearProgress> {
  // Duration _position = const Duration(minutes: 0);
  double percentage = 0;
  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    double percentage = 0;

    player.positionStream.listen((p) {
      Duration duration = player.duration!;
      setState(() {
        percentage =
            double.parse((p.inSeconds / duration.inSeconds).toStringAsFixed(1));
        // print(percentage);
      });
      // setState(() {
      //   print('heyy this is p value $p');
      //   // _position = p;
      // });
    });
    return LinearProgressIndicator(
      // value: percentage,
      value: 0.5,
      // value: double.parse(percentage.toStringAsFixed(1)),
      // valueColor: const AlwaysStoppedAnimation<Color>(
      //   Colors.red,
      // ),
    );
    // return SizedBox.shrink();
  }
}
