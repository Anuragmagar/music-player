import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(selectedSongProvider);
    return Center(
      child: Text('Home page ${song?.title} \n ${song?.artist}'),
    );
  }
}
