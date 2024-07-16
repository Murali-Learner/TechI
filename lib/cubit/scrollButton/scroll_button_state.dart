part of 'scroll_button_cubit.dart';

@immutable
sealed class ScrollButtonState {}

final class ScrollButtonShow extends ScrollButtonState {}

final class ScrollButtonHide extends ScrollButtonState {}
