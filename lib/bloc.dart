import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

// Simplyfied version of https://fluttersamples.com/ BLoC example
class Bloc extends BlocBase {
  //The inputs of our BLoC are Sinks.
  //The BLoC pattern prescribes to only use Streams and Sinks as the BLoCs In-/Out-puts.
  // Inputs
  final Sink countUp;

  //Outputs
  final String Function() initialState;
  final Stream<String> state;

  //Preventing memory leaks:
  // Cleanup
  final List<StreamSubscription<dynamic>> _subscriptions;

  @override
  void dispose() {
    countUp.close();
    _subscriptions.forEach((f) => f.cancel());
  }

  factory Bloc() {
    //The interactor contains the "real" business logic.
    // -> This means our BLoC is more responsible of routing Actions/Events to methods,
    //    instead of containing the logic itself.

    var interactor = BlocInteractor();

    final countUpController = StreamController<void>(sync: true);

    final subscriptions = <StreamSubscription<dynamic>>[
      countUpController.stream.listen(interactor.countUp),
    ];

    return Bloc._(
      interactor.state,
      countUpController.sink,
      subscriptions,
      () => interactor.initialState,
    );
  }

  Bloc._(
    this.state,
    this.countUp,
    this._subscriptions,
    this.initialState,
  );
}

class BlocInteractor {
  //Our State is represented by a Stream. A BehaviorSubject in this case.
  // State
  final BehaviorSubject<String> _state =
      BehaviorSubject<String>.seeded('Loading');

  //This is the Stream our UI uses for staying up to date.
  // .distinct() only emmits an event if the State really has changed.
  //  (imagine adding the same value multiple times in sequence)
  //Outputs
  Stream<String> get state => _state.stream.distinct();
  String get initialState => _state.value;

  void countUp(void x) {
    print('starting count');
    for (int i = 0; i <= 10; i++) {
      Timer(Duration(seconds: i), () {
        _state.add(i.toString());
      });
    }
  }
}
