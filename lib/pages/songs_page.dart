import 'dart:async';

import 'package:audio_app/pages/SongsPage/song_tile.dart';
import 'package:audio_app/pages/Sorting.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  // State<SongsPage> createState() => _SongsPageState();
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songListProvider);
    // SongModel song = songs![songIndex];

    if (songs == null) {
      return const Center(child: Text('No songs available in your device'));
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Sorting(),
        ),
        const SizedBox(height: 10),
        Expanded(
          // height: 200,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: ((context, index) {
              if (songs[index].duration! < 60000) {
                return const SizedBox.shrink();
              }

              return SongTile(index: index);
            }),
          ),
        )
      ],
    );
  }
}
