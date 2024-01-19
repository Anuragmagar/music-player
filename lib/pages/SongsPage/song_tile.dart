import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SongTile extends ConsumerStatefulWidget {
  final int index;
  const SongTile({required this.index, super.key});

  @override
  _SongTileState createState() => _SongTileState();
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

class _SongTileState extends ConsumerState<SongTile> {
  // late StreamSubscription<int?> indexStream;
  // Main method.
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    final songs = ref.watch(songListProvider);
    // int? songIndex = player.currentIndex;
    // SongModel song = songs![songIndex];

    if (songs == null) {
      return const Center(child: Text('No songs available in your device'));
    }

    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      children:
          songs.map((song) => AudioSource.uri(Uri.parse(song.uri!))).toList(),
    );

    return ListTile(
      onTap: () async {
        ref.read(isMiniplayerOpenProvider.notifier).update((state) => true);
        player.setAudioSource(playlist,
            initialIndex: widget.index, initialPosition: Duration.zero);
        player.play();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        songs[widget.index].title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${songs[widget.index].artist}・${formatDuration(songs[widget.index].duration)}',
        style: const TextStyle(color: Color.fromRGBO(218, 218, 218, 1)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: QueryArtworkWidget(
          controller: audioQuery,
          id: songs[widget.index].id,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.circular(10),
          nullArtworkWidget: Container(
            height: 50,
            width: 50,
            color: Colors.white60,
            child:
                const Icon(PhosphorIconsDuotone.musicNote, color: Colors.white),
          ),
        ),
      ),
      trailing: const Icon(
        PhosphorIconsFill.dotsThreeOutlineVertical,
        color: Color.fromRGBO(218, 218, 218, 1),
      ),
    );
  }
}
