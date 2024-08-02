part of 'cats_bloc.dart';
// States
abstract class CatsState {}
class CatsInitial extends CatsState {}
class CatsLoading extends CatsState {}
class CatsLoaded extends CatsState {
  final List<Cat> cats;
  CatsLoaded(this.cats);
}
class CatsError extends CatsState {
  final String message;
  CatsError(this.message);
}