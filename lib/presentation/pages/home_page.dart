import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wietapp/application/cats/cats_bloc.dart';
import 'package:wietapp/application/tier/tier_bloc.dart';
import 'package:wietapp/presentation/widgets/cat_grid_item.dart';
import 'package:wietapp/presentation/widgets/tier_indicator.dart';

class CatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cats'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Cats')],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CatsBloc, CatsState>(
                builder: (context, state) {
                  if (state is CatsInitial) {
                    BlocProvider.of<CatsBloc>(context).add(FetchCats());
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CatsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CatsLoaded) {
                    return GridView.builder(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [
                          const QuiltedGridTile(2, 2),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 2),
                        ],
                      ),
                      itemCount: state.cats.length,
                      itemBuilder: (context, index) {
                        return CatGridItem(cat: state.cats[index]);
                      },
                    );
                  } else if (state is CatsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container();
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<TierBloc, TierState>(
                builder: (context, state) {
                  if (state is TierInitial) {
                    BlocProvider.of<TierBloc>(context).add(FetchTierInfo());
                    return const SizedBox.shrink();
                  } else if (state is TierLoaded) {
                    return TierIndicator(
                      tiers: state.tiers,
                      currentTierName: state.currentTier,
                      currentPoints: state.tierPoints,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
