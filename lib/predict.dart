import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:alzaware/result.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flython/flython.dart';
import 'package:path_provider/path_provider.dart';

import 'Basic Resources/LoadingWidget.dart';

class PredictAlzAware extends StatefulWidget {

  String uId, recordCount;

  PredictAlzAware(this.uId, this.recordCount, {super.key});

  @override
  State<PredictAlzAware> createState() => _PredictAlzAwareState(uId, recordCount);
}

class _PredictAlzAwareState extends State<PredictAlzAware> {

  final voiceRecord = SoundRecorder();
  final audioPlay = AudioPlayer();
  int timerSeconds = 0, timerMinutes = 0, recordingCount = 0;
  String uId, recordCount, timerSecondsString = "00", timerMinutesString = "00", alzValue = "";
  Timer? timer;
  bool isPlayingStarted = false, isAudioPlaying = false, detailsLoaded = false, isPredicting = false;
  var userData;

  _PredictAlzAwareState(this.uId, this.recordCount);

  @override
  void initState(){
    super.initState();
    runPython();
    voiceRecord.init();
    audioPlay.init();
    detailsLoaded = true;
    setState(() {});
    //FirebaseDatabase fbData = FirebaseDatabase.instance;
    /*fbData.ref().child(uId).once().then((res){
      userData = res.snapshot.value;
      print(userData);
      detailsLoaded = true;
      if(userData["recordings"]!=null){
        recordingCount = userData["recordings"].keys.length;
      }
      else{
        recordingCount = 0;
      }
      setState(() {

      });
    });*/
  }

  @override
  void dispose(){
    voiceRecord.dispose();
    audioPlay.dispose();
    super.dispose();
  }

  void runPython() async{
    final opencv = OpenCV();
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.py');
    await file.writeAsString("print('hello world')");
    String fileContent = await file.readAsString();
    print(fileContent);
    await opencv.initialize("python", '${directory.path}/my_file.py', false);
    await opencv.toGray();
    opencv.finalize();
  }

  void timerStart(){
    if(timer==null){
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        timerSeconds++;
        if(timerSeconds==60){
          timerMinutes++;
          timerSeconds = 0;
        }
        if(timerSeconds>9){
          timerSecondsString = "$timerSeconds";
        }
        else{
          timerSecondsString = "0$timerSeconds";
        }
        if(timerMinutes>9){
          timerMinutesString = "$timerMinutes";
        }
        else{
          timerMinutesString = "0$timerMinutes";
        }
        setState(() {});
      });
    }
    else{
      if(!timer!.isActive){
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          timerSeconds++;
          if(timerSeconds==60){
            timerMinutes++;
            timerSeconds = 0;
          }
          if(timerSeconds>9){
            timerSecondsString = "$timerSeconds";
          }
          else{
            timerSecondsString = "0$timerSeconds";
          }
          if(timerMinutes>9){
            timerMinutesString = "$timerMinutes";
          }
          else{
            timerMinutesString = "0$timerMinutes";
          }
          setState(() {});
        });
      }
    }
  }

  void timerPause(){
    timer?.cancel();
    setState(() {

    });
  }

  void timerStop(){
    timer?.cancel();
    timerMinutes = 0;
    timerSeconds = 0;
    timerMinutesString = "00";
    timerSecondsString = "00";
    setState(() {

    });
  }

  Future uploadRecording() async{
    File file = File("/data/user/0/com.impeccablecreations.alzaware/cache/recording.aac");
    var storage = FirebaseStorage.instance;
    recordingCount++;
    var uploaded = await storage.ref().child(uId).child("/recording$recordingCount.aac").putFile(file);
    var dbInstance = FirebaseDatabase.instance;
    String recordingUrl = await uploaded.ref.getDownloadURL();
    alzValue = Random().nextInt(101).toString();
    var dbVal = {"recordingUrl": recordingUrl, "alzValue": alzValue};
    await dbInstance.ref().child(uId).child("/recordings/recording$recordingCount").set(dbVal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predict"),
      ),
      body: detailsLoaded?!isPredicting?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80)),
              border: Border.all( width: 4, color: Colors.black45),
              color: Color(0xFF77ADDC),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Icon(Icons.mic,color: Colors.red,),
                Text("$timerMinutesString : $timerSecondsString", style: TextStyle(color: Colors.white, fontSize: 36),),
                SizedBox(height: 20,),
              ],
            ),
          ),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(10.0),),
                  onPressed: (){
                    if(voiceRecord.isPaused){
                      voiceRecord.recordResume().then((res){
                        timerStart();
                      });
                    }
                    else{
                      if(voiceRecord.isInitialized && !voiceRecord.isRecording){
                        voiceRecord.recordStart().then((res){
                          timerStart();
                        });
                      }
                    }
                  },
                  child: Text("Record"),
                ),
              ),
              SizedBox(width: 20,),
              Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(10.0),),
                  onPressed: (){
                    if(voiceRecord.isRecording){
                      voiceRecord.recordPause().then((res){
                        timerPause();
                      });
                    }
                    else{
                      Toast.show("Please start recording!", textStyle: const TextStyle(color: Colors.red,), backgroundColor: Colors.white, duration: Toast.lengthLong);
                    }
                  },
                  child: Text("Pause"),
                ),
              ),
              SizedBox(width: 20,),
              Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(10.0),),
                  onPressed: (){
                    if(voiceRecord.isRecording){
                      voiceRecord.recordStop().then((res){
                        timerStop();
                      });
                    }
                    else{
                      Toast.show("Please start recording!", textStyle: const TextStyle(color: Colors.red,), backgroundColor: Colors.white, duration: Toast.lengthLong);
                    }
                  },
                  child: Text("Stop"),
                ),
              ),
            ],
          ),
          SizedBox(height: 50,),
          voiceRecord.isRecorded?Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 3),
                color: Color(0xFF77ADDC),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20,),
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: isPlayingStarted?LinearProgressIndicator(
                      color: Colors.white,
                    ):SizedBox(),
                  ),
                  IconButton(
                    onPressed: (){
                      if(audioPlay.isInitialized){
                        if(!isPlayingStarted){
                          audioPlay.audioPlay((){
                            isAudioPlaying = false;
                            isPlayingStarted = false;
                            setState(() {});
                          }).then((res){
                            isPlayingStarted = true;
                            isAudioPlaying = true;
                            setState(() {});
                          });
                        }
                        else if(audioPlay.isPaused){
                          audioPlay.audioResume().then((res){
                            isAudioPlaying = true;
                            setState(() {});
                          });
                        }
                        else{
                          audioPlay.audioPause().then((res){
                            isAudioPlaying = false;
                            setState(() {});
                          });
                        }
                        print(isAudioPlaying);
                      }
                    },
                    icon: Icon(isAudioPlaying?Icons.pause: Icons.play_arrow, color: Colors.white, size: 30,),
                  ),
                  IconButton(
                    onPressed: (){
                      if(audioPlay.isPlaying){
                        audioPlay.audioStop().then((res){
                          isPlayingStarted = false;
                          isAudioPlaying = false;
                        });
                      }
                      setState(() {});
                    },
                    icon: isPlayingStarted?Icon(Icons.stop, color: Colors.red, size: 30,):SizedBox(),
                  ),
                ],
              ),
            ),
          ):SizedBox(),
          SizedBox(height: 50,),
          Container(
            height: 50,
            width: 150,
            child: ElevatedButton(
              style: ButtonStyle(elevation: MaterialStateProperty.all(10.0),),
              onPressed: () async{
                isPredicting = true;
                setState(() {});
                await uploadRecording();
                isPredicting = false;
                setState(() {});
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultAlzAware(alzValue)));
              },
              child: Text("Predict"),
            ),
          ),
        ],
      ):LoadingWidget("Detecting Alzheimers"):LoadingWidget("Setting Up Recorder"),
    );
  }
}

class SoundRecorder{
  FlutterSoundRecorder? soundRecorder;
  bool isInitialized = false, isRecorded = false;

  bool get isRecording => soundRecorder!.isRecording;

  bool get isPaused => soundRecorder!.isPaused;

  Future init() async{
    soundRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException("Recording permission not granted");
    }
    await soundRecorder!.openAudioSession();
    isInitialized = true;
  }

  Future dispose() async{
    await soundRecorder!.closeAudioSession();
    soundRecorder = null;
    isInitialized = false;
  }

  Future recordStart() async{
    await soundRecorder!.startRecorder(toFile: "recording.wav",codec: Codec.pcm16WAV);
    isRecorded = false;
  }

  Future recordStop() async{
    await soundRecorder!.stopRecorder();
    isRecorded = true;
  }

  Future recordPause() async{
    await soundRecorder!.pauseRecorder();
  }

  Future recordResume() async{
    await soundRecorder!.resumeRecorder();
  }
}

class AudioPlayer{
  FlutterSoundPlayer? audioPlayer;
  bool isInitialized = false, isDone = false, isFinished = false;

  bool get isPlaying => audioPlayer!.isPlaying;

  bool get isPaused => audioPlayer!.isPaused;

  Future init() async{
    audioPlayer = FlutterSoundPlayer();
    await audioPlayer!.openAudioSession();
    isInitialized = true;
  }

  Future dispose() async{
    await audioPlayer!.closeAudioSession();
    audioPlayer = null;
    isInitialized = false;
  }

  Future audioPlay(VoidCallback whenFinished) async{
    await audioPlayer!.startPlayer(fromURI: "recording.wav", whenFinished: whenFinished,);
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

class OpenCV extends Flython {
  //static const cmdToGray = 1;

  Future<dynamic> toGray(
      //String inputFile,
      //String outputFile,
      ) async {
    var command = {
      //"cmd": cmdToGray,
      //"input": inputFile,
      //"output": outputFile,
    };
    print("togray");
    return await runCommand(command);
  }
}

