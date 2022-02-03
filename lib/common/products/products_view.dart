import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/products/productsViewBloc.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:universal_io/io.dart';

const CARD_PER_ROW = 3;
const IMAGE_HEIGHT = 100.0;

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key, required this.onProductTap}) : super(key: key);

  final void Function(Product) onProductTap;

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
              if (_snapshot.hasData && _snapshot.data!.isNotEmpty) {
                const padding = EdgeInsets.all(7);
                final width = _size == null
                    ? null
                    : (_size!.width - padding.horizontal) / CARD_PER_ROW;
                return SingleChildScrollView(
                  child: Padding(
                    padding: padding,
                    child: Wrap(
                      children: [
                        for (var item in _snapshot.data!)
                          _ProductView(
                            product: item,
                            width: width,
                            onTap: () => widget.onProductTap(item),
                          ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text("please select a category"));
            },
          );
        }
        return const Center(child: Text("please select a category"));
      },
    );
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView({
    Key? key,
    required this.product,
    this.width,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final double? width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        decimalPriceFormatter.format(product.price) + " / " + product.unit;
    return SizedBox(
      width: width,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(product.imagePath),
                const SizedBox(height: 3),
                Text(product.title, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    return imagePath != null
        ? Image.file(
            File(imagePath),
            fit: BoxFit.fitWidth,
            height: IMAGE_HEIGHT,
            width: double.infinity,
          )
        : Image.asset(
            'assets/images/placeholder.png',
            fit: BoxFit.fitHeight,
            height: IMAGE_HEIGHT,
            width: double.infinity,
          );
  }
}
