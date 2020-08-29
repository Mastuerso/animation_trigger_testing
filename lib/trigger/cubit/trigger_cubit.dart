import 'package:bloc/bloc.dart';

class Diff {
  final bool trigger;
  final int index;

  Diff(this.trigger, this.index);

  @override
  String toString() => 'Triggered $trigger at $index';
}

class TriggerCubit extends Cubit<Diff> {
  TriggerCubit() : super(Diff(false, 0));

  void fire(Diff event) {
    emit(Diff(event.trigger, event.index));
  }
}
