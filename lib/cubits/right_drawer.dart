import 'package:flutter_bloc/flutter_bloc.dart';

class RightDrawerCubit extends Cubit<bool> {
  RightDrawerCubit() : super(false);

  showDrawer() => emit(true);

  closeDrawer() => emit(false);
}
