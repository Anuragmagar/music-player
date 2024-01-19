import 'package:audio_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavbar extends ConsumerStatefulWidget {
  const BottomNavbar({super.key});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends ConsumerState<BottomNavbar> {
  // int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageProvider);
    return NavigationBar(
      backgroundColor: const Color.fromRGBO(42, 41, 49, 1),
      surfaceTintColor: const Color.fromRGBO(42, 41, 49, 1),
      selectedIndex: currentPage,
      onDestinationSelected: (index) {
        ref.read(currentPageProvider.notifier).update((state) => index);
      },
      destinations: const [
        NavigationDestination(
            icon: PhosphorIcon(PhosphorIconsFill.house), label: 'Home'),
        NavigationDestination(
            icon: PhosphorIcon(PhosphorIconsFill.vinylRecord), label: 'Albums'),
        NavigationDestination(
            icon: PhosphorIcon(PhosphorIconsFill.musicNote), label: 'Songs'),
        NavigationDestination(
            icon: PhosphorIcon(PhosphorIconsFill.playlist), label: 'Playlists'),
        NavigationDestination(
            icon: PhosphorIcon(PhosphorIconsFill.userList), label: 'Artists'),
      ],
    );
  }
}
