import 'package:flutter/material.dart';
import 'package:rental_app/functions/capitalize_first_letter.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/product_view_page/product_detailed_view.dart';

SliverList sliverProductDisplay(List<Product> products) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final binaryData = products[index].images[0].data;
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailedView(
                  product: products[index],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).cardTheme.color,
            ),
            child: Column(
              children: [
                Image.memory(
                  binaryData,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeFirstLetter(products[index].name),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text('Brand: ${products[index].brand}'),
                          Text('Color: ${products[index].color}'),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${products[index].price} \$',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const Divider(
                                height: 0,
                              ),
                              const Text('Month'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      childCount: products.length,
    ),
  );
}
