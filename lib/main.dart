import 'package:flutter/material.dart';

import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //Don't think Java 8+ Streams. Think Rx/Reactive.
    StreamController<String> controller = StreamController<String>.broadcast();
    //Using the .broadcast() constructor lets us register more than 1 listener!

    controller.stream.listen(print);
    //This is equivalent to
    //  controller.stream.listen((String msg) => print(msg));


    controller.stream.listen(printSpecial);
    //Oh yes! Now we don't crash anymore!


    //Now we add the newest state later than the creation of the StreamBuilder.
    //So finally our values get processed by it.
    for (int i = 0; i <= 10; i++) {
      Timer(Duration(seconds: i), () {
        controller.sink.add('$i');
      });
    }

    Timer(Duration(seconds: 11), () {
      controller.close();
    });


    //We will probably never see anything but the 'Loading' text :(
    return MaterialApp(
      builder: (context, widget) => Scaffold(
            body: Center(
              //We use this StreamBuilder to consume a stream.
              //Everytime the stream emits a new state, the builder will be triggered again.
              child: StreamBuilder(
                stream: controller.stream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData
                      ? Text(snapshot.data)
                      : Text('Loading');
                },
              ),
            ),
          ),
    );
  }

  printSpecial(String input) => print('*** $input ***');
}
