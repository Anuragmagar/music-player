import 'package:audio_app/pages/bottom_linear_progress.dart';
import 'package:audio_app/pages/player_screen.dart';
import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomMiniPlayer extends ConsumerStatefulWidget {
  const BottomMiniPlayer({super.key});

  @override
  _BottomMiniPlayerState createState() => _BottomMiniPlayerState();
}

class _BottomMiniPlayerState extends ConsumerState<BottomMiniPlayer> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final songs = ref.read(songListProvider);
    int songIndex = player.currentIndex!;
    SongModel selectedSong = songs![songIndex];

    // SongModel song = songs![songIndex];
    player.currentIndexStream.listen((p) {
      if (p != songIndex) {
        setState(() {
          selectedSong = songs[songIndex];
        });
      }
    });

    return GestureDetector(
      onTap: () {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromRGBO(24, 24, 26, 1),
          systemNavigationBarDividerColor: Color.fromRGBO(24, 24, 26, 1),
        ));
        Get.to(() => PlayerScreen(selectedSong),
            transition: Transition.downToUp);
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(42, 41, 49, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: QueryArtworkWidget(
                      controller: audioQuery,
                      id: selectedSong.id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(10),
                      nullArtworkWidget: Container(
                        color: Colors.black,
                        height: 50,
                        width: 50,
                        child: const Icon(PhosphorIconsDuotone.musicNote),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              selectedSong.title,
                              overflow: TextOverflow.ellipsis,
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .caption!
                              //     .copyWith(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.w500,
                              //     ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              selectedSong.artist.toString(),
                              overflow: TextOverflow.ellipsis,
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .caption!
                              //     .copyWith(
                              //         fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    // icon: const Icon(Icons.play_arrow),
                    icon: Icon(player.playing
                        ? PhosphorIconsFill.pause
                        : PhosphorIconsFill.play),
                    onPressed: () {
                      if (player.playing) {
                        player.pause();
                      } else {
                        player.play();
                      }
                    },
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   onPressed: () {
                  //     context.read(selectedVideoProvider).state =
                  //         null;
                  //   },
                  // ),
                ],
              ),
            ),
            const BottomLinearProgress(),
          ],
        ),
      ),
    );
  }
}
