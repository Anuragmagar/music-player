// import 'package:amlv/amlv.dart';
import 'dart:async';

import 'package:audio_app/manager/audio_player_manager.dart';
import 'package:audio_app/providers.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:mmoo_lyric/lyric.dart';
// import 'package:mmoo_lyric/lyric_controller.dart';
// import 'package:mmoo_lyric/lyric_util.dart';
// import 'package:mmoo_lyric/lyric_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class LyricsPage extends ConsumerStatefulWidget {
  final SongModel song;
  const LyricsPage(this.song, {super.key});

  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends ConsumerState<LyricsPage>
    with TickerProviderStateMixin {
  // LyricController? controller;

  // LrcLyricParser parser = LrcLyricParser();
  // Lyric? lyric;

  // List<Lyric>? lyric = [];
  String? lyric;
  double? position = 0;
  // Duration? position = const Duration(seconds: 0);
  // late StreamSubscription<Duration> durationState;
  final tagger = Audiotagger();

  var lyricUI = UINetease(
    highlight: false,
    defaultSize: 30,
    lyricAlign: LyricAlign.LEFT,
  );

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      getLyrics(widget.song.data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please grant storage permission')),
      );
    }
  }

  @override
  void initState() {
    // _loadLyrics();
    _requestStoragePermission();

    getLyrics(widget.song.data);
    super.initState();
  }

  @override
  void dispose() {
    durationState.drain();
    super.dispose();
  }

  getLyrics(String data) async {
    // final tagger = Audiotagger();

    final String filePath = data;
    // final AudioFile? audioFile = await tagger.readAudioFile(path: filePath);
    final Map? map = await tagger.readTagsAsMap(path: filePath);
    // final lyricParsed =
    //     await parser.parse(map!['lyrics'], UrlSource(widget.song.data));
    if (map == null) {
      // return null;
      lyric = null;
    }
    // lyric = await parser.parse(map!['lyrics'], UrlSource(data));
    // lyric = LyricUtil.formatLyric(map!['lyrics']);

    lyric = map!['lyrics'];
  }

  Stream<DurationState> durationState =
      Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
          player.positionStream,
          player.playbackEventStream,
          (position, playbackEvent) => DurationState(
                progress: position,
                buffered: playbackEvent.bufferedPosition,
                total: playbackEvent.duration,
                currentIndex: playbackEvent.currentIndex,
              ));
  @override
  Widget build(BuildContext context) {
    // final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DurationState>(
          stream: durationState,
          builder: (context, snapshot) {
            final durationState = snapshot.data;
            final progress = durationState?.progress ?? Duration.zero;
            final currentIndex = durationState?.currentIndex ?? 0;

            getLyrics(songs![currentIndex].data);

            if (lyric == null) {
              return const Center(
                child: Text("No lyrics"),
              );
            }

            // return LyricWidget(
            //   size: Size(double.infinity, MediaQuery.of(context).size.height),
            //   lyrics: lyric!,
            //   // progress: progress,
            //   controller: controller!,
            // );

// return LyricViewerControls(player: player, timeProgress: timeProgress, audioDuration: audioDuration, isPlaying: isPlaying, iconSize: iconSize, iconColor: iconColor,)
            // return LyricViewer(
            //   lyric: lyric!,
            //   onLyricChanged: (LyricLine line, String source) {
            //     // ignore: avoid_print
            //     print("$source: [${line.time}] ${line.content}");
            //   },
            //   onCompleted: () {
            //     // ignore: avoid_print
            //     print("Completed");
            //   },
            //   gradientColor1: const Color(0xFFCC9934),
            //   gradientColor2: const Color(0xFF444341),
            // );
            var lyricModel =
                LyricsModelBuilder.create().bindLyricToMain(lyric!).getModel();

            return LyricsReader(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              model: lyricModel,
              // model: lyric,
              position: progress.inMilliseconds.toInt(),
              lyricUi: lyricUI,
              // textStyle: const TextStyle(fontSize: 20),
              // playing: playing,
              playing: false,
              // size: Size(double.infinity, MediaQuery.of(context).size.height),
              selectLineBuilder: (p0, p1) {
                return Container();
              },

              emptyBuilder: () => const Center(
                child: Text(
                  "No lyrics",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
