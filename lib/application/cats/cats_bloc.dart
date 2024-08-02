import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wietapp/data/models/cat.dart';
import 'package:wietapp/data/repositories/cats_repository.dart';

part 'cats_event.dart';
part 'cats_state.dart';

// BLoC
class CatsBloc extends Bloc<CatsEvent, CatsState> {
  final CatsRepository repository;

  CatsBloc(this.repository) : super(CatsInitial()) {
    on<FetchCats>((event, emit) async {
      emit(CatsLoading());
      try {
        final data = await repository.fetchData();
        emit(CatsLoaded(data['cats']));
      } catch (e) {
        emit(CatsError(e.toString()));
      }
    });
  }
}