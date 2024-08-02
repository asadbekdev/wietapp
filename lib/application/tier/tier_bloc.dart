import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wietapp/data/models/tier.dart';
import 'package:wietapp/data/repositories/cats_repository.dart';

part 'tier_state.dart';
part 'tier_event.dart';

// BLoC
class TierBloc extends Bloc<TierEvent, TierState> {
  final CatsRepository repository;

  TierBloc(this.repository) : super(TierInitial()) {
    on<FetchTierInfo>((event, emit) async {
      emit(TierLoading());
      try {
        final data = await repository.fetchData();
        emit(TierLoaded(
          data['tiers'],
          data['currentTier'],
          data['tierPoints'],
        ));
      } catch (e) {
        emit(TierError(e.toString()));
      }
    });
  }
}
