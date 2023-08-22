import 'package:alzaware/portfolio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartAlzware extends StatefulWidget {

  List<ChartData> alzValueSeries;

  ChartAlzware(this.alzValueSeries);

  @override
  State<ChartAlzware> createState() => _ChartAlzwareState(alzValueSeries);
}

class _ChartAlzwareState extends State<ChartAlzware> {

  List<ChartData> alzValueSeries = [];

  _ChartAlzwareState(this.alzValueSeries);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alzheimer Chart"),
      ),
      body: Column(
        children: [
          Padding(
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
                Color(0xFF77ADDC),
              ],
            ),
          )
        ],
      ),
    );
  }
}
