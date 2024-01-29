import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Components/carousel_widget.dart';
import 'package:rental_app/Components/category_scroll_card.dart';
import 'package:rental_app/functions/capitalize_first_letter.dart';
import 'package:rental_app/functions/to_camel_case.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/home/providers/datafetched_completley_cubit.dart';
import 'package:rental_app/screens/home/providers/home_products_view_cubit.dart';
import 'package:rental_app/screens/home/services/home_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routename = '/home';

  static List<List<String>> categoryImgcardList = [
    [
      "card1",
      "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    ],
    [
      "card2",
      "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    ],
    [
      "card3",
      "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    ],
    [
      "card4",
      "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    ],
    [
      "card5",
      "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    ],
  ];

  static bool dataFetched = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Fetch random products only once when the home screen is first created
    if (!HomePage.dataFetched) {
      HomeServices.clearFecthHistory(fetchtoken());
      fetchRandomProducts();
    }
  }

  String fetchtoken() {
    final userTokenCubit = context.read<UserTokenCubit>();
    final String userToken = userTokenCubit.state is UserTokenLoadedState
        ? (userTokenCubit.state as UserTokenLoadedState).token
        : '';
    return userToken;
  }

  // Function to fetch random products
  void fetchRandomProducts() {
    HomeServices.fetchRandomProducts(2, fetchtoken(), context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserInitialState) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      } else if (state is UserLoadedState) {
        final UserModel user = state.user;
        // if (user.userId == 'guest') {
        //   // Handle the case where user is null
        //   return const Scaffold(
        //     body: Center(
        //       child: Text("User data is null"),
        //     ),
        //   );
        // }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Welcome ${user.name}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CategoryScrollCard(
                        imgCardList: HomePage.categoryImgcardList,
                        isNetworkImage: true,
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Carousel(),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      "New Products",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                BlocBuilder<HomeProductViewCubit, HomeProductViewState>(
                  builder: (context, state) {
                    if (state is HomeProductViewInitialState) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: LinearProgressIndicator(),
                        ),
                      );
                    } else if (state is HomeProductViewLoadedState) {
                      List<Product> products = state.products;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final binaryData =
                                products[index].images[index].data;
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.memory(
                                      binaryData,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      capitalizeFirstLetter( products[index].name),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(products[index].description),
                                    // Text(
                                    //     'Product Id: ${products[index].productId}'),
                                    Text(
                                        'Category: ${products[index].category}'),
                                    Text('Brand: ${products[index].brand}'),
                                    products[index].model != ""
                                        ? Text(
                                            'model: ${products[index].model}')
                                        : const SizedBox(),
                                    products[index].size != ""
                                        ? Text('Size: ${products[index].size}')
                                        : const SizedBox(),
                                    Text('Price: ${products[index].price}'),
                                    Text('Color: ${products[index].color}'),
                                    products[index].material != ""
                                        ? Text(
                                            'Material: ${products[index].material}')
                                        : const SizedBox(),
                                    // Text(
                                    //     'Item Count: ${products[index].itemCount}'),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: products.length,
                        ),
                      );
                    } else {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text("Unknown State"),
                        ),
                      );
                    }
                  },
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<HomeDataFetchedCubit, HomeDataFetchState>(
                    builder: (context, state) {
                      if (state is HomeDataFetchInitialState) {
                        return TextButton(
                          child: const Text('Load More'),
                          onPressed: () {
                            HomeServices.fetchRandomProducts(
                                2, fetchtoken(), context);
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: Text("Unknown State"),
          ),
        );
      }
    });
  }
}
