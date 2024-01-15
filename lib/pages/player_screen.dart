import 'package:audio_app/pages/artwork_widget.dart';
import 'package:audio_app/pages/lyrics_page.dart';
import 'package:audio_app/pages/playing_title.dart';
import 'package:audio_app/pages/slider_page.dart';
import 'package:audio_app/pages/song_title_page.dart';
import 'package:audio_app/providers.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
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

  late Future<Gradient?> _generatedGradient;

  late String lyric;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _generateGradientFromImage();
    // _generatedGradient = _generateGradientFromImage();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(42, 41, 49, 1),
      systemNavigationBarDividerColor: Color.fromRGBO(42, 41, 49, 1),
    ));

    // _generatedGradient = _generateGradientFromImage();
    // WidgetsBinding.instance.addPostFrameCallback({

    // });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(42, 41, 49, 1),
      systemNavigationBarDividerColor: Color.fromRGBO(42, 41, 49, 1),
    ));
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generatedGradient = _generateGradientFromImage();
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

  Future<Gradient?> _generateGradientFromImage() async {
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

    final List<Color> colors = [
      paletteGenerator.dominantColor?.color ?? Colors.white,
      // paletteGenerator.darkVibrantColor?.color ?? Colors.white,
      // paletteGenerator.darkMutedColor?.color ?? Colors.white,
      const Color.fromRGBO(24, 24, 26, 1)
    ];

    final List<double> stops = [0.0, 0.6];

    return LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
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

  // _generateGradientFromImage();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;

    // final song = ref.watch(selectedSongProvider);
    final songs = ref.watch(songListProvider);
    final player = ref.read(playerProvider);
    final songIndex = player.currentIndex;
    final song = songs![songIndex!];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 24, 26, 1),
      body: FutureBuilder<Gradient?>(
        future: _generatedGradient,
        builder: (BuildContext context, AsyncSnapshot<Gradient?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Container(
              decoration: BoxDecoration(gradient: snapshot.data),
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
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
