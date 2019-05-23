import 'package:flutter/material.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BehaviorSubject<String> behaviorSubject =
        BehaviorSubject<String>.seeded('Loading');
    //Using RxDarts BehaviorSubject allows us to easily access the last
    //emitted value.
    //Also we can subscribe multiple times.

    behaviorSubject.stream.listen(print);
    //This is equivalent to
    //  controller.stream.listen((String msg) => print(msg));

    behaviorSubject.stream.listen(printSpecial);
    //Oh yes! Now we don't crash anymore!

    //Now we add the newest state later than the creation of the StreamBuilder.
    //So finally our values get processed by it.
    for (int i = 1; i <= 10; i++) {
      Timer(Duration(seconds: i), () {
        behaviorSubject.sink.add('$i');
      });
    }

    Timer(Duration(seconds: 11), () {
      behaviorSubject.close();
    });

    //We will probably never see anything but the 'Loading' text :(
    return MaterialApp(
      builder: (context, widget) => Scaffold(
            body: Center(
              //We use this StreamBuilder to consume a stream.
              //Everytime the stream emits a new state, the builder will be triggered again.
              child: StreamBuilder(
                stream: behaviorSubject.stream,

                //Accessing the last emitted value:
                initialData: behaviorSubject.value,
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
