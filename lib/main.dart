import 'package:flutter/material.dart';

import 'bloc.dart';

void main() => runApp(MyApp());

//Converted the StatelessWidget to a StatefulWidget.
//Since our BLoC is supposed to represent our State,
// in most cases the BLoC should be placed inside a StatefulWidgets State
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Here comes our first BLoC!
  Bloc bloc = Bloc();

  // The rest hasn't changed much.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => Scaffold(
            body: Center(
              child: StreamBuilder(
                initialData: bloc.initialState(),
                stream: bloc.state,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data, textScaleFactor: 4),
                      RaisedButton(
                        child: Text('Count!'),
                        onPressed: () => bloc.countUp.add(null),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
    );
  }

}
