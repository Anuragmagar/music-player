import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

final selectedSongProvider = StateProvider<SongModel?>((ref) {
  return null;
});

void updateSelectedSong(WidgetRef ref, SongModel newSong) {
  ref.read(selectedSongProvider.notifier).state = newSong;
}

final isNavVisibleProvider = StateProvider<bool>((ref) => true);

final songListProvider = StateProvider<List<SongModel>?>((ref) {
  return null;
});

final songsCountProvider = StateProvider((ref) => 0);

final playerProvider = StateProvider((ref) => AudioPlayer());

final isMiniplayerOpenProvider = StateProvider<bool>((ref) => false);
