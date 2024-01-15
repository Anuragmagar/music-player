import 'package:audio_app/pages/Sorting.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  // State<SongsPage> createState() => _SongsPageState();
  _SongsPageState createState() => _SongsPageState();
}

String formatDuration(int? milliseconds) {
  if (milliseconds == null) {
    return 'Unknown duration';
  }

  Duration duration = Duration(milliseconds: milliseconds);
  String minutes = '${duration.inMinutes}'.padLeft(2, '0');
  String seconds = '${duration.inSeconds % 60}'.padLeft(2, '0');
  return '$minutes:$seconds';
}

class _SongsPageState extends ConsumerState<SongsPage> {
  // Main method.
  final OnAudioQuery audioQuery = OnAudioQuery();

  // Define the playlist
  // final playlist = ConcatenatingAudioSource(
  // Start loading next item just before reaching it
  // useLazyPreparation: true,
  // Customise the shuffle algorithm
  // shuffleOrder: DefaultShuffleOrder(),
  // Specify the playlist items
  // children: [
  // AudioSource.uri(Uri.parse('https://example.com/track1.mp3')),
  // AudioSource.uri(Uri.parse('https://example.com/track2.mp3')),
  // AudioSource.uri(Uri.parse('https://example.com/track3.mp3')),
  // ],
  // children: songs.map((song) => AudioSource.uri(Uri.parse('https://example.com/track1.mp3'))).toList()
  // children: songs.map((song) => AudioSource.uri(Uri.parse(song))).toList(),
  // );

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songListProvider);
    // final player = AudioPlayer();
    final player = ref.read(playerProvider);
    return Column(
      children: [
        const SizedBox(height: 10),
        const Sorting(),
        const SizedBox(height: 10),
        Expanded(
          // height: 200,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: songs!.length,
            itemBuilder: ((context, index) {
              if (songs[index].duration! < 60000) {
                return const SizedBox.shrink();
              }

              // Define the playlist
              final playlist = ConcatenatingAudioSource(
                // Start loading next item just before reaching it
                useLazyPreparation: true,
                children: songs
                    .map((song) => AudioSource.uri(Uri.parse(song.uri!)))
                    .toList(),
              );

              return ListTile(
                onTap: () async {
                  // ref
                  //     .read(selectedSongProvider.notifier)
                  //     .update((state) => songs[index]);

                  ref
                      .read(isMiniplayerOpenProvider.notifier)
                      .update((state) => true);
                  player.setAudioSource(playlist,
                      initialIndex: index, initialPosition: Duration.zero);
                  player.play();
                },
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  songs[index].title,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${songs[index].artist}・${formatDuration(songs[index].duration)}',
                  style:
                      const TextStyle(color: Color.fromRGBO(218, 218, 218, 1)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: QueryArtworkWidget(
                    controller: audioQuery,
                    id: songs[index].id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(10),
                    nullArtworkWidget: Container(
                      height: 50,
                      width: 50,
                      color: Colors.black,
                      child: const Icon(PhosphorIconsDuotone.musicNote),
                    ),
                  ),
                ),
                trailing: const Icon(
                  PhosphorIconsFill.dotsThreeOutlineVertical,
                  color: Color.fromRGBO(218, 218, 218, 1),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
