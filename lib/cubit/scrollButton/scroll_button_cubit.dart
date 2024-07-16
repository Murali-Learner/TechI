import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'scroll_button_state.dart';

class ScrollButtonCubit extends Cubit<ScrollButtonState> {
  ScrollButtonCubit() : super(ScrollButtonHide());

  void setScrollButtonVisibility(bool isShow) {
    isShow ? emit(ScrollButtonShow()) : emit(ScrollButtonHide());
  }
}
