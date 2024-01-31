import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/functions/capitalize_first_letter.dart';
import 'package:rental_app/models/product_model.dart';

class ProductDetailedView extends StatefulWidget {
  const ProductDetailedView({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailedView> createState() => _ProductDetailedViewState();
}

class _ProductDetailedViewState extends State<ProductDetailedView> {
  final String heroFavoriteTag = 'herofavorite';
  bool showMoreDetails = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: heroFavoriteTag,
        label: const Text("Favorite"),
        onPressed: () {},
        icon: const Icon(Icons.favorite_border_rounded),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                itemCount: widget.product.images.length,
                autoplay: true,
                loop: true,
                autoplayDisableOnInteraction: true,
                scrollDirection: Axis.horizontal,
                pagination: SwiperPagination(
                  builder: SwiperCustomPagination(
                    builder: (BuildContext context, SwiperPluginConfig config) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: config.itemCount * 16,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: config.itemCount > 0
                                ? List.generate(
                                    config.itemCount,
                                    (index) => Container(
                                      margin: const EdgeInsets.all(4.0),
                                      width: 6.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == config.activeIndex
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  )
                                : [],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: Image.memory(
                      widget.product.images[index].data,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      capitalizeFirstLetter(widget.product.name),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Text(
                    capitalizeFirstLetter(
                        '${widget.product.description}hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh'),
                    maxLines: showMoreDetails ? 20 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Brand: ${capitalizeFirstLetter(widget.product.brand)}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Category: ${capitalizeFirstLetter(widget.product.category)}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Color: ${capitalizeFirstLetter(widget.product.color)}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            if (showMoreDetails)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.product.model != "")
                                    Text(
                                      'model: ${capitalizeFirstLetter(widget.product.model)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (widget.product.size != "")
                                    Text(
                                      'Size: ${capitalizeFirstLetter(widget.product.size)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (widget.product.material != "")
                                    Text(
                                      'Material: ${capitalizeFirstLetter(widget.product.material)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  Text(
                                    'In-stock: ${widget.product.itemCount} units',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 3,
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${widget.product.price} \$',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const Divider(thickness: 2, height: 0),
                              const Text(
                                'Month',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showMoreDetails = !showMoreDetails;
                        });
                      },
                      child: Text(
                        showMoreDetails ? 'Show Less' : 'Show More',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    width: double.infinity,
                    child: IconButton.filledTonal(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        icon: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    width: double.infinity,
                    child: IconButton(
                        // highlightColor:  Colors.green[200],
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green[200]),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        icon: const Text(
                          "Rent now",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
