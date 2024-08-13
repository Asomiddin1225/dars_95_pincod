import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PIN Kiritish')),
      body: Center(
        child: Pinput(
          length: 4,
          onCompleted: (pin) {
            // PIN kiritilganda bajariladigan amallar
            print('Kiritilgan PIN: $pin');
          },
        ),
      ),
    );
  }
}