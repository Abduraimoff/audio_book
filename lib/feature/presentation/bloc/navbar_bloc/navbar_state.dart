part of 'navbar_bloc.dart';

class NavBarState extends Equatable {
  const NavBarState(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}
