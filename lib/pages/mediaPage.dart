import 'package:mum_s/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:mum_s/pages/login_page.dart';
import 'package:mum_s/style/constants.dart';
import 'package:mum_s/utils/connectivity.dart';
import 'package:mum_s/utils/user_actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mum_s/utils/snack_bar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:mum_s/style/theme.dart' as Theme;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:mum_s/utils/apiKey.dart';
import 'package:mum_s/classes/video.dart';

late User? loggedInUser;
var usersCollection = FirebaseFirestore.instance.collection('Users');

ConnectivityClass c_class = ConnectivityClass();
final _auth = FirebaseAuth.instance;

class mediaPage extends StatefulWidget {
  const mediaPage({Key? key}) : super(key: key);

  @override
  State<mediaPage> createState() => _mediaPageState();
}

class _mediaPageState extends State<mediaPage> {
  List<Video> videos = [];
  YoutubeAPI youtube = YoutubeAPI(apiKey, type: 'video');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final videoURL =
      'https://www.youtube.com/watch?v=YMx8Bbev6T4&t=1s&ab_channel=FlutterUIDev';

  late YoutubePlayerController _videoController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    c_class.getConnectivity(context);
    c_class.checkInternet(context);
    // This function is printing the users name and its email
    loggedInUser = getCurrentUser();

    final videoId = YoutubePlayer.convertUrlToId(videoURL);

    _videoController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_videoController.value.isFullScreen) {
      setState(() {
        _playerState = _videoController.value.playerState;
        _videoMetaData = _videoController.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        onEnded: (data) {
          print('here is what will get printed' + data.toString());
        },
        controller: _videoController,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: DraggableFab(
          child: SizedBox(
            height: 65,
            width: 65,
            child: FloatingActionButton(
              backgroundColor: kFloatingActionButtonColor,
              child: const Icon(
                size: 35,
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                c_class.checkInternet(context);
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
                showInSnackBar('Logged out Successfully', Colors.green, context,
                    _scaffoldKey.currentContext!);
              },
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: kAppBarColor,
          title: const Center(
            child: Text(
              'My Media',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.person,
                            color: kFloatingActionButtonColor,
                            size: 40.0,
                          )),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                      c_class.checkInternet(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: player,
            ),
          ],
        ),
      ),
    );
  }
}
