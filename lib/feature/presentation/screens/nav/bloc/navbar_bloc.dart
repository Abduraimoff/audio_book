import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarState(0)) {
    on<NavBarEvent>(_onNavBarChangedTabEvent);
  }

  Future<void> _onNavBarChangedTabEvent(
    NavBarEvent event,
    emit,
  ) async {
    emit(NavBarState(event.index));
  }
}
