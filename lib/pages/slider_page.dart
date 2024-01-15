import 'package:audio_app/providers.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SliderPage extends ConsumerStatefulWidget {
  const SliderPage({super.key});

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends ConsumerState<SliderPage> {
  // late Duration _position;
  Duration _position = const Duration(minutes: 0);
  Duration _bufferedPosition = const Duration(minutes: 0);
  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);

    player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });

    player.bufferedPositionStream.listen((p) {
      setState(() {
        _bufferedPosition = p;
      });
    });

    // player.icy

    // final songs = ref.watch(songListProvider);
    // SongModel selectedSong = ref.watch(selectedSongProvider)!;
    // int songIndex = player.currentIndex!;
    // SongModel song = songs![songIndex];

    // if (selectedSong.id != song.id) {
    //   ref
    //       .read(selectedSongProvider.notifier)
    //       .update((state) => songs[songIndex]);
    //   selectedSong = songs[songIndex];
    //   // player.currentIndexStream.listen((p) {
    //   // if (p != songIndex) {
    //   // }

    //   // setState(() {
    //   //   songIndex = p!;
    //   //   song = songs[songIndex];
    //   // });
    //   // });
    // }
    return Consumer(builder: ((context, ref, child) {
      return ProgressBar(
        // progress: Duration(minutes: 1),
        progress: _position,
        // total: Duration(minutes: 3, seconds: 30),
        total: player.duration!,
        onSeek: (value) {
          player.seek(value);
        },
        buffered: _bufferedPosition,
      );
    }));
  }
}
