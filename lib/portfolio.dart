import 'package:alzaware/Basic%20Resources/LoadingWidget.dart';
import 'package:alzaware/chart.dart';
import 'package:alzaware/edit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PortfolioAlzAware extends StatefulWidget {

  String uId;

  PortfolioAlzAware(this.uId, {super.key});

  @override
  State<PortfolioAlzAware> createState() => _PortfolioAlzAwareState(uId);
}

class _PortfolioAlzAwareState extends State<PortfolioAlzAware> {

  String uId, advice = "Follow these:\n1)An apple a day keeps doctor away\n2)Drink more water\n3)Eat oil-less food";
  bool detailsLoaded = false;
  var userData;
  List<ChartData> alzValueSeries = [];
  List<String> alzValues = [];
  
  _PortfolioAlzAwareState(this.uId);

  @override
  void initState(){
    super.initState();
    FirebaseDatabase fbData = FirebaseDatabase.instance;
    fbData.ref().child(uId).once().then((res){
      userData = res.snapshot.value;
      if(userData["advice"]!=null){
        advice = userData["advice"];
      }
      detailsLoaded = true;
      for(int i=0; i< userData["recordings"].keys.length; i++){
        var val = userData["recordings"].values.elementAt(i)["alzValue"];
        print(val);
        alzValueSeries.add(ChartData(i+1, double.parse(userData["recordings"].values.elementAt(i)["alzValue"])));
      }
      print(userData);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Portfolio"),
      ),
      body: detailsLoaded?Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
                  color: Color(0xFF6F8FAF),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.4,
                child: Column(
                  children: [
                    SizedBox(height: 80,),
                    Text("Hello!", style: TextStyle(color: Colors.white, fontSize: 26, fontStyle: FontStyle.italic),),
                    Text(detailsLoaded?userData["fullname"]:"", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 160,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      items: [
                        Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                            side: const BorderSide(
                              width: 3,
                              color: Colors.black45,
                            ),
                          ),
                          child: Center(child: Text(advice, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChartAlzware(alzValueSeries),));
                          },
                          child: Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                              side: const BorderSide(
                                width: 3,
                                color: Colors.black45,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SfCartesianChart(
                                  series: [
                                    BarSeries(
                                      dataSource: alzValueSeries,
                                      xValueMapper: (ChartData data, _)=> data.x,
                                      yValueMapper: (ChartData data, _)=> data.y,
                                    ),
                                  ],
                                  isTransposed: true,
                                  palette: [
                                    Colors.white,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.15,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20,),
                        Icon(Icons.email, color: Colors.white,),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width *0.5,
                          child: Text(detailsLoaded?userData["email"]:"", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 16),),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20,),
                        Icon(Icons.phone, color: Colors.white,),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width *0.5,
                          child: Text(detailsLoaded?userData["phone"]:"", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 16),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ):LoadingWidget("Fetching User Portfolio"),
    );
  }
}

class ChartData{
  final double x,y;
  ChartData(this.x, this.y);
}
