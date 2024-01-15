import 'package:amlv/amlv.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LyricsPage extends StatefulWidget {
  final SongModel song;
  const LyricsPage(this.song, {super.key});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  LrcLyricParser parser = LrcLyricParser();
  Lyric? lyric;

  @override
  void initState() {
    _loadLyrics();

    super.initState();
  }

  _loadLyrics() async {
    final tagger = Audiotagger();

    final String filePath = widget.song.data;
    // final AudioFile? audioFile = await tagger.readAudioFile(path: filePath);
    final Map? map = await tagger.readTagsAsMap(path: filePath);
    lyric = await parser.parse(map!['lyrics'], UrlSource(widget.song.data));
    setState(() {});
  }

  Future<Lyric> getLyrics() async {
    final tagger = Audiotagger();

    final String filePath = widget.song.data;
    // final AudioFile? audioFile = await tagger.readAudioFile(path: filePath);
    final Map? map = await tagger.readTagsAsMap(path: filePath);
    final lyricParsed =
        await parser.parse(map!['lyrics'], UrlSource(widget.song.data));

    // return map['lyrics'];
    return lyricParsed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getLyrics(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Loading lyrics... Please Wait'));
            }
            return snapshot.data != null
                ? LyricViewer(
                    lyric: snapshot.data!,
                    onLyricChanged: (LyricLine line, String source) {
                      // ignore: avoid_print
                      // print("$source: [${line.time}] ${line.content}");
                    },
                    onCompleted: () {
                      // ignore: avoid_print
                      print("Completed");
                    },
                    gradientColor1: const Color(0xFFCC9934),
                    gradientColor2: const Color(0xFF444341),
                  )
                : const Center(child: Text('No lyrics available'));
          }),
        ),
      ),
      // body: lyric != null
      //     ? LyricViewer(
      //         lyric: lyric!,
      //         onLyricChanged: (LyricLine line, String source) {
      //           // ignore: avoid_print
      //           print("$source: [${line.time}] ${line.content}");
      //         },
      //         onCompleted: () {
      //           // ignore: avoid_print
      //           print("Completed");
      //         },
      //         gradientColor1: const Color(0xFFCC9934),
      //         gradientColor2: const Color(0xFF444341),
      //       )
      //     : const Center(child: Text('No lyrics available')),
    );
  }
}
