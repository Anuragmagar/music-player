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
    return StylishBottomBar(
      backgroundColor: const Color.fromRGBO(42, 41, 49, 1),
      option: AnimatedBarOptions(
        barAnimation: BarAnimation.fade,
        iconStyle: IconStyle.animated,
        opacity: 0.3,
      ),
      items: [
        BottomBarItem(
          icon: const PhosphorIcon(
            PhosphorIconsFill.house,
          ),
          selectedColor: Colors.green,
          title: const Text('Home'),
        ),
        BottomBarItem(
          icon: const Icon(
            PhosphorIconsFill.vinylRecord,
            size: 25,
          ),
          selectedColor: Colors.green,
          title: const Text('Albums'),
          // backgroundColor: Colors.orange,
        ),
        BottomBarItem(
          icon: const Icon(
            PhosphorIconsFill.musicNote,
            size: 25,
          ),
          selectedColor: Colors.green,
          title: const Text('Songs'),
          // backgroundColor: Colors.purple,
        ),
        BottomBarItem(
          icon: const Icon(
            PhosphorIconsFill.playlist,
            size: 25,
          ),
          selectedColor: Colors.green,
          title: const Text('Playlists'),
          // backgroundColor: Colors.purple,
        ),
        BottomBarItem(
          icon: const Icon(
            PhosphorIconsFill.userList,
            size: 25,
          ),
          selectedColor: Colors.green,
          title: const Text('Artists'),
        ),
      ],
      currentIndex: currentPage,
      onTap: (index) {
        ref.read(currentPageProvider.notifier).update((state) => index);
        // setState(() {
        //   currentPage = index;
        //   // controller.jumpToPage(index);
        // });
      },
    );
  }
}
