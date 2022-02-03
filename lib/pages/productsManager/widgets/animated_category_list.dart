import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/products/productsViewBloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/running_assets/dao_access.dart';

class AnimatedCategoryList extends StatefulWidget {
  const AnimatedCategoryList({Key? key}) : super(key: key);

  @override
  _AnimatedCategoryListState createState() => _AnimatedCategoryListState();
}

class _AnimatedCategoryListState extends State<AnimatedCategoryList> {
  List<String> cachedDistinctCategories = [];
  List<String> distinctCategories = [];
  final listKey = GlobalKey<AnimatedListState>();
  late StreamSubscription<List<String>> categoryListener;
  String? selected;

  @override
  void initState() {
    super.initState();
    setup();
  }

  setup() async {
    const gapModifier = 100;
    const animDuration = Duration(milliseconds: 500);
    categoryListener = productDao.distinctCategories.listen((categories) {
      categories.sort((a, b) => b.compareTo(a));

      var counter = 0;
      final categoriesToAdd =
          categories.where((x) => !distinctCategories.contains(x));
      final addFutures = categoriesToAdd.map((c) async {
        await Future.delayed(Duration(milliseconds: ++counter * gapModifier));
        final i = categories.indexOf(c);
        listKey.currentState?.insertItem(i, duration: animDuration);
      }).toList();

      final categoriesToDelete =
          distinctCategories.where((x) => !categories.contains(x));
      final delFutures = categoriesToDelete.map((c) async {
        await Future.delayed(const Duration(milliseconds: gapModifier));
        listKey.currentState?.removeItem(
          distinctCategories.indexOf(c),
          (_ctx, animation) => _animRow(_ctx, c, animation),
          duration: animDuration,
        );
      }).toList();

      Future.wait(delFutures).then((_) {
        Future.wait(addFutures);
        setState(() {
          cachedDistinctCategories = distinctCategories;
          distinctCategories = categories;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    categoryListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      reverse: true,
      initialItemCount: distinctCategories.length,
      itemBuilder: (_ctx, index, animation) {
        String category = "";
        if (index >= 0 && index < distinctCategories.length) {
          category = distinctCategories.elementAt(index);
        } else if (index >= 0 && index < cachedDistinctCategories.length) {
          category = cachedDistinctCategories.elementAt(index);
        }
        return _animRow(_ctx, category, animation);
      },
    );
  }

  Widget _animRow(
    BuildContext _context,
    String category,
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.2),
          end: const Offset(0, 0),
        ).animate(animation),
        child: _buildCategoryView(category),
      ),
    );
  }

  Widget _buildCategoryView(String category) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isSelected = selected == category;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: RectButton(
        onPressed: () {
          setState(() => selected = category);
          context.read<ProductsBloc>().add(CategoryChangedEvent(category));
        },
        color: isSelected ? secondary : Colors.white,
        child: Text(
          category,
          style: TextStyle(color: !isSelected ? onSurface : null),
        ),
      ),
    );
  }
}
