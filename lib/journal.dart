import 'dart:io';
import 'package:alzaware/Basic%20Resources/LoadingWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:path_provider/path_provider.dart';

class JournalAlzAware extends StatefulWidget {

  String uId;

  JournalAlzAware(this.uId, {super.key});

  @override
  State<JournalAlzAware> createState() => _JournalAlzAwareState(uId);
}

class _JournalAlzAwareState extends State<JournalAlzAware> {


  var storage = FirebaseStorage.instance;
  var audioPlay = AudioPlayer();
  List<bool> playingValList = [], isPlayingStarted = [];
  bool fileInitialized = false, detailsLoaded = false;
  String uId;
  List<String> recordingUrls = [];
  List<File> recordings = [];
  var userData;

  _JournalAlzAwareState(this.uId);

  @override
  void initState(){
    super.initState();
    audioPlay.init();
    FirebaseDatabase fbData = FirebaseDatabase.instance;
    fbData.ref().child(uId).once().then((res){
      userData = res.snapshot.value;
      for(int i=userData["recordings"].keys.length-1;i>=0;i--){
        recordingUrls.add(userData["recordings"].values.elementAt(i)["recordingUrl"]);
        playingValList.add(false);
        isPlayingStarted.add(false);
      }
      detailsLoaded = true;
      setState(() {

      });
    });
  }

  @override
  void dispose(){
    audioPlay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journals"),
      ),
      body: detailsLoaded?ListView.builder(
        itemCount: recordingUrls.length,
        itemBuilder: (context,i){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              tileColor: const Color(0xFF77ADDC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: isPlayingStarted[i]?LinearProgressIndicator(color: Colors.white,):Text("Recording"+(i+1).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(playingValList[i]?Icons.pause:Icons.play_arrow, color: Colors.white, size: 30,),
                      onPressed: (){
                        if(playingValList[i]){
                          audioPlay.audioPause().then((res){
                            playingValList[i] = false;
                            setState(() {});
                          });
                        }
                        else{
                          if(isPlayingStarted[i]){
                            audioPlay.audioResume().then((res){
                              playingValList[i] = true;
                              setState(() {});
                            });
                          }
                          else{
                            audioPlay.audioPlay(recordingUrls[i],(){
                              playingValList[i] = false;
                              isPlayingStarted[i] = false;
                              setState(() {});
                            }).then((res){
                              playingValList[i] = true;
                              isPlayingStarted[i] = true;
                              setState(() {});
                            });
                          }
                        }

                      },
                    ),
                    isPlayingStarted[i]?IconButton(
                      onPressed: (){
                        audioPlay.audioStop().then((res) {
                          playingValList[i] = false;
                          isPlayingStarted[i] = false;
                          setState(() {});
                        });
                      },
                      icon: Icon(Icons.stop, color: Colors.red,),
                    ):SizedBox(),
                  ],
                ),
              ),
            ),
          );
        },
      ):LoadingWidget("Fetching Recordings"),
    );
  }
}

class AudioPlayer{
  FlutterSoundPlayer? audioPlayer;
  bool isInitialized = false, isDone = false;

  bool get isPlaying => audioPlayer!.isPlaying;

  bool get isPaused => audioPlayer!.isPaused;

  Future init() async{
    audioPlayer = FlutterSoundPlayer();
    /*final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException("Recording permission not granted");
    }*/
    await audioPlayer!.openAudioSession();
    isInitialized = true;
  }

  Future dispose() async{
    await audioPlayer!.closeAudioSession();
    audioPlayer = null;
    isInitialized = false;
  }

  Future audioPlay(filePath, whenFinished) async{
    await audioPlayer!.startPlayer(fromURI: filePath, whenFinished: whenFinished);
  }

  Future audioStop() async{
    await audioPlayer!.stopPlayer();
  }

  Future audioPause() async{
    await audioPlayer!.pausePlayer();
  }

  Future audioResume() async{
    await audioPlayer!.resumePlayer();
  }
}
