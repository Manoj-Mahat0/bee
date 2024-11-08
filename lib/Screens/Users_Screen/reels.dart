import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ReelsPage extends StatefulWidget {
  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> with TickerProviderStateMixin {
  final List<String> _videoIds = [
    'NcucscvoxyM',
    'DtQqo67viWg',
    '3hSsLZBRUAY',
    'T6id8FuUcao',
    '9E06Nxeq-84',
    'e1kKW1ftvgg',
    '7NmT6_rmRtw',
    '27-LnwyucFE',
  ];

  late List<YoutubePlayerController> _controllers;
  late List<bool> _liked;
  late List<AnimationController> _likeAnimControllers;

  @override
  void initState() {
    super.initState();
    _controllers = _videoIds
        .map((videoId) => YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: true,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        controlsVisibleAtStart: false,
        hideControls: true,
      ),
    ))
        .toList();

    _liked = List<bool>.filled(_videoIds.length, false);
    _likeAnimControllers = List.generate(
      _videoIds.length,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var animController in _likeAnimControllers) {
      animController.dispose();
    }
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      _liked[index] = !_liked[index];
      if (_liked[index]) {
        _likeAnimControllers[index].forward(from: 0.0);
      } else {
        _likeAnimControllers[index].reverse();
      }
    });
  }

  void _shareVideo(String videoId) {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    Share.share('Check out this video: $url');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videoIds.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controllers[index],
                      showVideoProgressIndicator: false,
                    ),
                    builder: (context, player) {
                      return player;
                    },
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(index),
                      child: ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.2)
                            .animate(CurvedAnimation(
                            parent: _likeAnimControllers[index],
                            curve: Curves.easeOut)),
                        child: _buildActionButton(
                          Icons.favorite,
                          'Like',
                          isLiked: _liked[index],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      child: _buildActionButton(Icons.comment, 'Comment'),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _shareVideo(_videoIds[index]),
                      child: _buildActionButton(Icons.share, 'Share'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {bool isLiked = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5),
          ),
          child: Icon(
            icon,
            color: isLiked ? Colors.red : Colors.white,
            size: 30,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
