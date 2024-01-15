import 'package:audio_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  // final player = StateProvider<SongModel>((ref) {
  //   ref.read(playerProvider);
  // });

  // Stream<DurationState>? durationState;

  void init() {
    // durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
    //     player.positionStream,
    //     player.playbackEventStream,
    //     (position, playbackEvent) => DurationState(
    //           progress: position,
    //           buffered: playbackEvent.bufferedPosition,
    //           total: playbackEvent.duration,
    //         ));
    // player.setUrl(url);
  }

  void dispose() {
    // player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
