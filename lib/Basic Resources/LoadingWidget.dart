import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {

  String message;

  LoadingWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Color(0xFF77ADDC),),
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(color: Color(0xFF77ADDC),),),
          ],
        )
      ],
    );
  }
}
