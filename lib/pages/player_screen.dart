import 'dart:async';

import 'package:audio_app/pages/artwork_widget.dart';
import 'package:audio_app/pages/playing_title.dart';
import 'package:audio_app/pages/slider_page.dart';
import 'package:audio_app/pages/song_title_page.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final SongModel song;
  const PlayerScreen(this.song, {super.key});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  late StreamSubscription<int?> indexStream;

  late String lyric;

  List<Color> colors = [
    const Color.fromRGBO(24, 24, 26, 1),
    const Color.fromRGBO(24, 24, 26, 1)
  ];
  List<double> stops = [0.0, 0.6];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _generateGradientFromImage();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(42, 41, 49, 1),
      systemNavigationBarDividerColor: Color.fromRGBO(42, 41, 49, 1),
    ));
  }

  @override
  void dispose() {
    indexStream.cancel();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(42, 41, 49, 1),
      systemNavigationBarDividerColor: Color.fromRGBO(42, 41, 49, 1),
    ));

    super.dispose();
  }

  // getLyric() async {
  //   final tagger = Audiotagger();

  //   final String filePath = widget.song.data;
  //   // final AudioFile? audioFile = await tagger.readAudioFile(path: filePath);
  //   final Map? map = await tagger.readTagsAsMap(path: filePath);
  //   setState(() {
  //     lyric = map!['lyric'];
  //   });
  // }

  _generateGradientFromImage() async {
    final player = ref.watch(playerProvider);
    final songs = ref.read(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel selectedSong = songs![songIndex];

    final imageBytes = await getArtworkBytes(selectedSong.id);

    if (imageBytes == null) {
      return null;
    }

    final image = await decodeImageFromList(imageBytes);

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImage(image);

    setState(() {
      colors = [
        paletteGenerator.dominantColor?.color ?? Colors.white,
        const Color.fromRGBO(24, 24, 26, 1)
      ];
    });
  }

  Future<Uint8List?> getArtworkBytes(int audioId) async {
    final player = ref.watch(playerProvider);
    final songs = ref.read(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel selectedSong = songs![songIndex];

    return await audioQuery.queryArtwork(
      selectedSong.id,
      ArtworkType.AUDIO,
    );
  }

  @override
  void didUpdateWidget(covariant PlayerScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _generateGradientFromImage();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;

    final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel song = songs![songIndex];

    _generateGradientFromImage();
    indexStream = player.currentIndexStream.listen((p) {
      if (p != songIndex) {
        setState(() {
          songIndex = p!;
          song = songs[songIndex];
          // _generateGradientFromImage();
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 26, 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: height, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            children: [
              const PlayingTitle(),
              const SizedBox(height: 50),
              const ArtworkWidget(),
              const SizedBox(height: 50),
              const SongTitlePage(),
              const SizedBox(height: 25),
              const SliderPage(),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    PhosphorIconsRegular.repeat,
                    size: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        player.seekToPrevious();
                      });
                    },
                    child: const Icon(
                      PhosphorIconsFill.skipBack,
                      size: 25,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (player.playing) {
                        setState(() {
                          player.pause();
                        });
                      } else {
                        setState(() {
                          player.play();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Icon(
                          player.playing
                              ? PhosphorIconsFill.pause
                              : PhosphorIconsFill.play,
                          size: 25,
                          color: const Color.fromRGBO(52, 35, 35, 1),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        player.seekToNext();
                      });
                    },
                    child: const Icon(
                      PhosphorIconsFill.skipForward,
                      size: 25,
                    ),
                  ),
                  const Icon(
                    PhosphorIconsRegular.shuffle,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(height: 35),
              const Text(
                'M4A · 162 KBPS · 44.1 KHZ',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
