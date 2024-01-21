import 'dart:typed_data';

import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final OnAudioQuery audioQuery = OnAudioQuery();

  // _generateGradientFromImage(SongModel song) async {
  Future<Map<String, Color>?> _generateGradientFromImage(SongModel song) async {
    final imageBytes = await getArtworkBytes(song);

    if (imageBytes != null) {
      final image = await decodeImageFromList(imageBytes);

      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImage(image);

      return {
        'dominant': paletteGenerator.dominantColor?.color ?? Colors.black,
        'lightVibrant':
            paletteGenerator.lightVibrantColor?.color ?? Colors.black,
        'vibrant': paletteGenerator.vibrantColor?.color ?? Colors.black,
        'darkVibrant': paletteGenerator.darkVibrantColor?.color ?? Colors.black,
        'lightMuted': paletteGenerator.lightMutedColor?.color ?? Colors.white,
        'muted': paletteGenerator.mutedColor?.color ?? Colors.white,
        'darkMuted': paletteGenerator.darkMutedColor?.color ?? Colors.white,
      };
    }
  }

  Future<Uint8List?> getArtworkBytes(SongModel audioId) async {
    return await audioQuery.queryArtwork(
      audioId.id,
      ArtworkType.AUDIO,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(recentSongListProvider);

    if (song == null) {
      return const Text('No song');
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(43, 71, 132, 238),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          PhosphorIconsBold.clockCounterClockwise,
                          color: Color(0xFF4785EE),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'History',
                      style:
                          TextStyle(color: Color.fromARGB(216, 255, 255, 255)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(43, 233, 31, 98),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          PhosphorIconsBold.heart,
                          color: Color(0xFFE91F63),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Favourites',
                      style:
                          TextStyle(color: Color.fromARGB(216, 255, 255, 255)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(43, 51, 168, 82),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          PhosphorIconsBold.trendUp,
                          color: Color(0xFF33A853),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Most played',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color.fromARGB(216, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(43, 251, 189, 3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Icon(
                              PhosphorIconsBold.shuffle,
                              color: Color(0xFFFBBB03),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Shuffle',
                      style:
                          TextStyle(color: Color.fromARGB(216, 255, 255, 255)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              print('tapped');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recently Added songs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(
                  PhosphorIconsBold.arrowRight,
                  color: Colors.purpleAccent[100],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: song.length,
            // itemCount: 10,
            itemBuilder: (context, index) {
              // final colors = _generateGradientFromImage(song[index]);
              // print(colors);
              // print(_generateGradientFromImage(song[index]));
              // return FutureBuilder<List<Color>?>(
              return FutureBuilder<Map<String, Color>?>(
                future: _generateGradientFromImage(song[index]),
                builder: (context, snapshot) {
                  // print(snapshot.data);
                  return Container(
                    margin: const EdgeInsets.only(left: 20),

                    // height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          right: 0,
                          child: QueryArtworkWidget(
                            controller: audioQuery,
                            id: song[index].id,
                            type: ArtworkType.AUDIO,
                            artworkHeight: 160,
                            artworkWidth: 160,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.brown,
                              ),
                              child: const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                // stops: [0, 1],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: const [0.4, 1],
                                colors: [
                                  snapshot.data?['dominant'] ??
                                      Colors.transparent,
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            song[index].title,
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: snapshot
                                                      .data?['darkVibrant'] ??
                                                  Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            song[index].artist.toString() ==
                                                    '<unknown>'
                                                ? 'Unknown Artist'
                                                : song[index].artist.toString(),
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: TextStyle(
                                              height: 1,
                                              color: snapshot
                                                      .data?['darkVibrant'] ??
                                                  Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 35.0, right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: const Color.fromRGBO(
                                              192, 192, 192, 0.5),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            PhosphorIconsFill.play,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
