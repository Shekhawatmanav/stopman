import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key ? key}):super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int seconds = 0, minutes = 0 , hours = 0;
  String digitSeconds = "00", digitMinutes = "00" , digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void Stop(){
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void Reset(){
    timer !.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitHours = "00";
      digitMinutes = "00";

      started = false;

      laps.clear();
    });
  }

  void AddLaps(){
    String lap = "$digitHours : $digitMinutes : $digitSeconds";
    setState(() {
      if(started){
        laps.add(lap);
      }else{
        Fluttertoast.showToast(
        msg: "Start Timer",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16
        );
      }
    }); 
  }

  void Start(){
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer){
      int localSeconds = seconds + 1;
      int localMinutes = minutes ; 
      int localHours = hours ;

      if(localSeconds > 59) {
        if(localMinutes >59){
          localHours++;
          localMinutes = 0;
        }else {
          localMinutes++ ;
          localSeconds = 0;
        }

      }

      setState(() {
        seconds = localSeconds ;
        minutes = localMinutes ; 
        hours = localHours ;
        digitSeconds = (seconds >= 10) ?"$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ?"$minutes" : "0$minutes";
        digitHours = (hours >= 10) ?"$hours" : "0$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("StopMan : StopWatch",
                style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),
              ),
            
              Center(child: Text("$digitHours:$digitMinutes:$digitSeconds", style: TextStyle(color: Colors.white,fontSize: 82,fontWeight: FontWeight.w600), ),),
              Container(
                height: 400,
                decoration: BoxDecoration(color: 
                Color(0xFF323F68),
                borderRadius: BorderRadius.circular(8)),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lap ${index+1}", style: TextStyle(color: Colors.white, fontSize: 16),),
                          Text("${laps[index]}", style: TextStyle(color: Colors.white, fontSize: 16),)
                        ],
                      ),
                    );
                  },),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Expanded(
                child: 
                RawMaterialButton(
                  onPressed: (){
                    (!started) ? Start() : Stop();                  
                    },
                  shape: const StadiumBorder(
                    side: BorderSide(
                      color: Colors.blue),),
                      child: Text(
                        (!started) ? "Start" : "Pause", style: TextStyle(color: Colors.white),),
                  )
                  ),
                  IconButton(color: Colors.white ,onPressed: (){
                    AddLaps();
                  }, icon: Icon(Icons.flag)),
                  Expanded(
                child: 
                RawMaterialButton(
                  onPressed: (){
                    Reset();
                  },
                  fillColor: Colors.blue,
                  shape: const StadiumBorder(),
                      child: Text("Reset", style: TextStyle(color: Colors.white),),
                  )
                  )
                  ],
                  ),

            ],
          ),),
      ),

    );
  }
  
}
