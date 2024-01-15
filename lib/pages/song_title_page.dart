import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SongTitlePage extends ConsumerStatefulWidget {
  const SongTitlePage({super.key});

  @override
  _SongTitlePageState createState() => _SongTitlePageState();
}

class _SongTitlePageState extends ConsumerState<SongTitlePage> {
  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel song = songs![songIndex];
    player.currentIndexStream.listen((p) {
      setState(() {
        songIndex = p!;
        song = songs[songIndex];
      });
    });

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (song.title.length < 35)
                Flexible(
                  child: Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 23,
                      fontFamily: 'CircularStd',
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (song.title.length >= 35)
                SizedBox(
                  // width: 250.0,
                  width: double.infinity,
                  height: 30,
                  child: Marquee(
                    text: song.album.toString(),
                    style: const TextStyle(
                      fontSize: 23,
                      fontFamily: 'CircularStd',
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 25.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    decelerationCurve: Curves.easeOut,
                    startAfter: const Duration(seconds: 3),
                  ),
                ),
              Flexible(
                child: Text(
                  song.artist.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'CircularStd',
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    color: Color.fromRGBO(179, 179, 178, 1),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(PhosphorIconsRegular.heart),
        )
      ],
    );
  }
}
