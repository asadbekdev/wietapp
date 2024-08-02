
part of 'tier_bloc.dart';
// States

abstract class TierState {}
class TierInitial extends TierState {}
class TierLoading extends TierState {}
class TierLoaded extends TierState {
  final List<Tier> tiers;
  final String currentTier;
  final int tierPoints;
  TierLoaded(this.tiers, this.currentTier, this.tierPoints);
}
class TierError extends TierState {
  final String message;
  TierError(this.message);
}