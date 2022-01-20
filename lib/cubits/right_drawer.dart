import 'package:flutter_bloc/flutter_bloc.dart';

class RightDrawerCubit extends Cubit<RightDrawerState> {
  RightDrawerCubit() : super(RightDrawerState(false, 0));

  showDrawer(int index) => emit(RightDrawerState(true, index));

  closeDrawer(int index) => emit(RightDrawerState(false, index));
}

class RightDrawerState {
  final bool show;
  final int index;

  RightDrawerState(this.show, this.index);
}
