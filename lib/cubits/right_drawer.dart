import 'package:flutter_bloc/flutter_bloc.dart';

class RightDrawerCubit extends Cubit<RightDrawerState> {
  RightDrawerCubit() : super(RightDrawerState(false, 0, null));

  void showDrawer({int? index, String? title}) =>
      emit(RightDrawerState(true, index ?? 0, title));

  void closeDrawer({int? index, String? title}) {
    final _index = index ?? state.index;
    final _title = title ?? state.title;
    emit(RightDrawerState(false, _index, _title));
  }
}

class RightDrawerState {
  final bool show;
  final int index;
  final String? title;

  RightDrawerState(this.show, this.index, this.title);
}
