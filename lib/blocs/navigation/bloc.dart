import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, int> {
  NavigationBloc() : super(0) {
    on<NavigationChangeEvent>((event, emit) {
      emit(event.index);
    });
  }
}

abstract class NavigationEvent {}

class NavigationChangeEvent extends NavigationEvent {
  final int index;

  NavigationChangeEvent({required this.index});
}
