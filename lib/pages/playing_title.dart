import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlayingTitle extends ConsumerStatefulWidget {
  const PlayingTitle({super.key});

  @override
  _PlayingTitleState createState() => _PlayingTitleState();
}

class _PlayingTitleState extends ConsumerState<PlayingTitle> {
  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel song = songs![songIndex];
    player.currentIndexStream.listen((p) {
      if (p != songIndex) {
        setState(() {
          songIndex = p!;
          song = songs[songIndex];
        });
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            PhosphorIconsBold.caretDown,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Flexible(
                  child: Text(
                    'PLAYING FROM ALBUM',
                    style: TextStyle(fontFamily: 'CircularStd', fontSize: 13),
                  ),
                ),
                if (song.album!.length < 35)
                  Flexible(
                    child: Text(
                      song.album.toString(),
                      style: const TextStyle(
                        fontFamily: 'CircularStd',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (song.album!.length >= 35)
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: Marquee(
                      text: song.album.toString(),
                      style: const TextStyle(
                        fontFamily: 'CircularStd',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 25.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      decelerationCurve: Curves.easeOut,
                      startAfter: const Duration(seconds: 3),
                    ),
                  )
              ],
            ),
          ),
        ),
        const Icon(PhosphorIconsBold.dotsThreeVertical)
      ],
    );
  }
}
