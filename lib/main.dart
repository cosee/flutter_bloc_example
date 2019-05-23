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

    controller.sink.add('test1');
    controller.sink.add('test2');
    //Repeatedly hot-loading the app should show, 
    //that sometimes 'test1' is not even printed!

    controller.close();
    //Always close your streams before (i.e.) changing context to prevent memory leaks!
    //Strictly speaking this is NOT the place to do this. Still, this is just an example.

    return MaterialApp(builder: (context, widget) => Container());
  }

  printSpecial(String input) => print('*** $input ***');
}
