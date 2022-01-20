import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/products/bloc.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final _key = GlobalKey();

  Size? _size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() => _size = _key.currentContext?.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      key: _key,
      builder: (_, _state) {
        if (_state.runtimeType == StreamedProducts) {
          final stream = (_state as StreamedProducts).stream;
          return StreamBuilder<List<Product>>(
            stream: stream,
            builder: (_, _snapshot) {
              if (_snapshot.hasData) {
                const padding = EdgeInsets.symmetric(horizontal: 7);
                final width = _size == null
                    ? null
                    : (_size!.width - padding.horizontal) / 3;
                return Padding(
                  padding: padding,
                  child: Container(
                    color: colorScheme(context).primary,
                    child: Wrap(
                      children: [
                        for (var item in _snapshot.data!)
                          _ProductView(product: item, width: width),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        } else {
          return const Center(child: Text("please select a category"));
        }
      },
    );
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView({Key? key, required this.product, this.width})
      : super(key: key);

  final Product product;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final color = colorScheme(context).primary;
    return SizedBox(
      width: width,
      child: Card(
        child: ListTile(
          title: Text(product.title),
          subtitle: Text(priceFormatter.format(product.price)),
          focusColor: color,
        ),
      ),
    );
  }
}
