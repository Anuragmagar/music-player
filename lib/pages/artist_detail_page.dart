import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:http/http.dart' as http;

class ArtistDetailPage extends StatefulWidget {
  final int noOfAlbums;
  final int id;
  final int noOfTracks;
  final String artist;
  const ArtistDetailPage(
      {this.noOfAlbums = 0,
      this.artist = '',
      this.id = 0,
      this.noOfTracks = 0,
      super.key});

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage>
    with SingleTickerProviderStateMixin {
  final OnAudioQuery audioQuery = OnAudioQuery();

  late ScrollController _scrollController;
  bool _isExpanded = false;
  String bio = '';
  bool isGettingArtistBio = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getArtistBio();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });

    // WidgetsBinding.instance.addPostFrameCallback((_) => getArtistBio());
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (400 - kToolbarHeight);
  }

  getArtistBio() async {
    var url = Uri.parse(
        'https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=${widget.artist}&api_key=2dbaf6156c82a38328d4590f297043bf&format=json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        bio = jsonResponse['artist']['bio']['content'];
        isGettingArtistBio = false;
      });
    }
    return response.statusCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: const Color.fromRGBO(28, 27, 32, 1),
            pinned: true,
            // centerTitle: true,
            expandedHeight: 400,
            title: _isSliverAppBarExpanded
                ? Text(
                    widget.artist,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  )
                : null,
            flexibleSpace: _isSliverAppBarExpanded
                ? null
                : FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(left: 0),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        QueryArtworkWidget(
                          // artworkHeight: 150,
                          // artworkWidth: 150,
                          artworkFit: BoxFit.cover,
                          controller: audioQuery,
                          id: widget.id,
                          type: ArtworkType.ARTIST,
                          artworkBorder: BorderRadius.circular(10),
                          size: 1000,
                          nullArtworkWidget: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              PhosphorIconsFill.userList,
                              color: Colors.grey,
                              size: 64,
                            ),
                          ),
                        ),
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: [0, 1],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xFF1B1C20)],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        widget.artist,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'CircularStd',
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: Text(
              '${widget.noOfTracks} Songs・09:33',
              textAlign: TextAlign.center,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Songs',
                    style: TextStyle(
                        fontFamily: 'Grover',
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Biography',
                    style: TextStyle(
                        fontFamily: 'Grover',
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: isGettingArtistBio
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                Text(
                                  bio,
                                  maxLines: _isExpanded ? null : 3,
                                ),
                                _isExpanded
                                    ? const SizedBox.shrink()
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'More',
                                            style:
                                                TextStyle(color: Colors.purple),
                                            textAlign: TextAlign.right,
                                          ),
                                          Icon(
                                            PhosphorIconsRegular.caretDown,
                                            color: Colors.purple,
                                            size: 16,
                                          )
                                        ],
                                      )
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 300,
          //     color: Colors.pink,
          //   ),
          // ),
        ],
      ),
    );
  }
}
