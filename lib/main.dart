import 'package:audio_app/pages/albums_page.dart';
import 'package:audio_app/pages/artists_page.dart';
import 'package:audio_app/pages/BottomMiniplayer/bottom_mini_player.dart';
import 'package:audio_app/pages/bottom_navbar.dart';
import 'package:audio_app/pages/home_page.dart';
import 'package:audio_app/pages/player_screen.dart';
import 'package:audio_app/pages/playlists_page.dart';
import 'package:audio_app/pages/songs_page.dart';
import 'package:audio_app/providers.dart';
import 'package:audio_app/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: 'CircularStd',
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      // darkTheme: ThemeData(
      //     useMaterial3: true,
      //     colorScheme: darkColorScheme,
      //     fontFamily: 'OpenSans'),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  // State<MyHomePage> createState() => _MyHomePageState();
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  List<Widget> pages = const [
    HomePage(),
    AlbumsPage(),
    SongsPage(),
    PlaylistsPage(),
    ArtistsPage(),
  ];

  int songsCount = 0;
  // Main method.
  final OnAudioQuery audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;
  @override
  void initState() {
    super.initState();

    _checkPermissions();
    checkAndRequestPermissions();

    getSongs();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(42, 41, 49, 1),
      systemNavigationBarDividerColor: Color.fromRGBO(42, 41, 49, 1),
    ));
  }

  _checkPermissions() async {
    if (!await Permission.storage.request().isGranted) {
      await _checkPermissions();
    }
  }

  checkAndRequestPermissions({bool retry = true}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission
        ? setState(() {})
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  const Text('Please grant storage permission to use the app'),
              action: SnackBarAction(
                label: 'Grant',
                onPressed: () {
                  checkAndRequestPermissions(retry: true);
                },
              ),
            ),
          );
  }

  getSongs() async {
    List<SongModel> audios = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    List<SongModel> filteredAudios = [];
    for (var audio in audios) {
      if (audio.duration != null && audio.duration! > 60000) {
        filteredAudios.add(audio);
      }
    }
    ref.read(songListProvider.notifier).update((state) => filteredAudios);
    ref
        .read(songsCountProvider.notifier)
        .update((state) => filteredAudios.length);
  }

  @override
  Widget build(BuildContext context) {
    bool isMiniplayerOpen = ref.watch(isMiniplayerOpenProvider);

    final int currentPage = ref.watch(currentPageProvider);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
        scrolledUnderElevation: 0,
        title: TextField(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            prefixIcon: Icon(
              PhosphorIcons.list(),
              color: const Color(0xfff2f2f2),
            ),
            hintText: 'Search your music',
            hintStyle: Theme.of(context).textTheme.titleMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(84),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Padding(
            // padding: const EdgeInsets.only(right: 20, left: 16),
            // child:
            IndexedStack(index: currentPage, children: pages),
            // ),
            if (isMiniplayerOpen)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomMiniPlayer(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
// Widget noAccessToLibraryWidget() {
//   return Center(
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.redAccent.withOpacity(0.5),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text("Application doesn't have access to the library"),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => checkAndRequestPermissions(retry: true),
//             child: const Text("Allow"),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
