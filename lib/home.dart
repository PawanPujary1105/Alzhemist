import 'package:alzaware/journal.dart';
import 'package:alzaware/portfolio.dart';
import 'package:alzaware/predict.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAlzAware extends StatefulWidget {

  final String uId;

  const HomeAlzAware(this.uId, {super.key});

  @override
  State<HomeAlzAware> createState() => _HomeAlzAwareState(uId);
}

class _HomeAlzAwareState extends State<HomeAlzAware> {

  String uId, recordCount = "1";

  _HomeAlzAwareState(this.uId);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 50,),
            Text("AlzAware"),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: (){
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((res) {
                Navigator.pop(context);
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Icon(Icons.logout),
                  Text("Logout"),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PortfolioAlzAware(uId)));
            },
            child: MenuCard("assets/images/portfolio.png", "Portfolio"),
          ),
          const Row(
            children: [
              SizedBox(height: 30,)
            ],
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PredictAlzAware(uId, recordCount)));
            },
            child: MenuCard("assets/images/prediction.png", "Predict"),
          ),
          const SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>JournalAlzAware(uId)));
            },
            child: MenuCard("assets/images/journal.png", "Journal"),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {

  String assetPath, menuText;
  double cardHeight = 0.0, cardWidth = 0.0;
  MenuCard(this.assetPath, this.menuText, {super.key});

  @override
  Widget build(BuildContext context) {
    cardWidth = MediaQuery.of(context).size.width*0.8;
    cardHeight = MediaQuery.of(context).size.height*0.20;
    return SizedBox(
      height: cardHeight,
      width: cardWidth,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Image(image: AssetImage(assetPath),),
            ),
            const SizedBox(width: 20,),
            Text(menuText, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
            const SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }
}

