import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultAlzAware extends StatefulWidget {

  String alzValue;
  ResultAlzAware(this.alzValue);

  @override
  State<ResultAlzAware> createState() => _ResultAlzAwareState(alzValue);
}

class _ResultAlzAwareState extends State<ResultAlzAware> {

  int predictionStartValue = 80, predictionEndValue = 86;
  double predictionAvgValue = 0;
  String alzValue;

  _ResultAlzAwareState(this.alzValue);

  @override
  Widget build(BuildContext context) {
    //predictionAvgValue = (predictionStartValue+predictionEndValue)/2;
    predictionAvgValue = double.parse(alzValue);
    predictionStartValue = int.parse(alzValue)-3;
    predictionEndValue = int.parse(alzValue)+3;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alzheimer's Prediction"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 25,
                    startWidth: 50,
                    endWidth: 50,
                    color: Colors.red,
                  ),
                  GaugeRange(
                    startValue: 25,
                    endValue: 50,
                    startWidth: 50,
                    endWidth: 50,
                    color: Colors.yellow,
                  ),
                  GaugeRange(
                    startValue: 50,
                    endValue: 75,
                    startWidth: 50,
                    endWidth: 50,
                    color: Colors.blue,
                  ),
                  GaugeRange(
                    startValue: 75,
                    endValue: 100,
                    startWidth: 50,
                    endWidth: 50,
                    color: Colors.green,
                  ),
                ],
                pointers: [
                  NeedlePointer(value: predictionAvgValue, needleEndWidth: 20, needleLength: 0.8,),
                ],
                showLabels: false,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$predictionStartValue% - $predictionEndValue% confident", style: const TextStyle(fontSize: 18,color: Color(0xFF77ADDC), fontWeight: FontWeight.bold),),
            ],
          ),
          const Text("that you have Alzheimer's", style: TextStyle(fontSize: 18,color: Color(0xFF77ADDC), fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
