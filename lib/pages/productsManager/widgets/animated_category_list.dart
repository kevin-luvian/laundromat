import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laundry/blocs/products/bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:provider/src/provider.dart';

class AnimatedCategoryList extends StatefulWidget {
  const AnimatedCategoryList({Key? key}) : super(key: key);

  @override
  _AnimatedCategoryListState createState() => _AnimatedCategoryListState();
}

class _AnimatedCategoryListState extends State<AnimatedCategoryList> {
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
    const gapModifier = 70;
    const animDuration = Duration(milliseconds: 500);
    categoryListener = productDao.distinctCategories().listen((categories) {
      var counter = 0;

      final prevCategoriesLength = distinctCategories.length;
      categories.where((x) => !distinctCategories.contains(x)).forEach((_) {
        Future.delayed(Duration(milliseconds: counter++ * gapModifier))
            .then((_) {
          listKey.currentState
              ?.insertItem(prevCategoriesLength, duration: animDuration);
        });
      });

      counter = 0;
      distinctCategories.where((x) => !categories.contains(x)).forEach((c) {
        Future.delayed(Duration(milliseconds: counter++ * gapModifier)).then(
          (_) {
            final i = distinctCategories.indexOf(c);
            listKey.currentState?.removeItem(
              i,
              (_context, animation) => _animRow(_context, i, animation),
              duration: animDuration,
            );
          },
        );
      });

      setState(() => distinctCategories = categories);
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
      itemBuilder: _animRow,
    );
  }

  Widget _animRow(_context, index, animation) {
    final category = distinctCategories[index];
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, -0.1),
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
