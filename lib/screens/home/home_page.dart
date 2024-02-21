import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Auth/services/auth_services.dart';
import 'package:rental_app/Components/carousel_widget.dart';
import 'package:rental_app/Components/category_scroll_card.dart';
import 'package:rental_app/Components/sliver_product_display.dart';
import 'package:rental_app/models/product_model.dart';
// import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/home/providers/datafetched_completley_cubit.dart';
import 'package:rental_app/screens/home/providers/home_products_view_cubit.dart';
import 'package:rental_app/screens/home/services/home_services.dart';
import 'package:rental_app/screens/search/search_result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routename = '/home';

  static List<List> categoryImgcardList = [
    ["testCategory1", "assets/images/test.jpeg", Icons.abc, Colors.brown],
    ["testCategory2", "assets/images/test.jpeg", Icons.abc, Colors.brown],
    [
      "Living room Furniture",
      "assets/images/test.jpeg",
      Icons.living,
      Colors.brown,
    ],
    [
      "Living room Appliances",
      "assets/images/test.jpeg",
      Icons.tv,
      Colors.blueGrey
    ],
    [
      "Bed room Furniture",
      "assets/images/test.jpeg",
      Icons.bed,
      Colors.brown
    ],
    [
      "Bed room Appliances",
      "assets/images/test.jpeg",
      Icons.lightbulb_outline,
      Colors.blueGrey
    ],
    [
      "kitchen Furniture",
      "assets/images/test.jpeg",
      Icons.table_bar,
      Colors.brown
    ],
    [
      "kitchen Appliances",
      "assets/images/test.jpeg",
      Icons.kitchen_outlined,
      Colors.blueGrey
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

    if (!HomePage.dataFetched) {
      HomeServices.clearFetchHistory(fetchtoken());
      fetchRandomProducts();
    }
  }

  String fetchtoken() {
    final userTokenCubit = context.read<UserTokenCubit>();

    final String userToken = userTokenCubit.state is UserTokenLoadedState
        ? (userTokenCubit.state as UserTokenLoadedState).token
        : 'no token';

    return userToken;
  }

  // Function to fetch random products
  void fetchRandomProducts() {
    HomeServices.fetchRandomProducts(2, fetchtoken(), context);
  }

  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    Future<void> onrefresh() async {
      setState(() {
        HomePage.dataFetched = false;
      });
      HomeDataFetchedCubit homeDataFetchState =
          context.read<HomeDataFetchedCubit>();
      homeDataFetchState.falseStatus();
      final productHomeViewCubit = context.read<HomeProductViewCubit>();
      productHomeViewCubit.clearProducts(); //
      HomeServices.clearFetchHistory(fetchtoken());
      fetchRandomProducts();
    }

    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserInitialState) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      } else if (state is UserLoadedState) {
        // final UserModel user = state.user;
        // if (user.userId == 'guest') {
        //   // Handle the case where user is null
        //   return const Scaffold(
        //     body: Center(
        //       child: Text("User data is null"),
        //     ),
        //   );
        // }
        AuthService.tokenVerify(context, fetchtoken());
        return Scaffold(
          appBar: AppBar(
            title: TextFormField(
              readOnly: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchResultPage(),
                ));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8.0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          body: BlocBuilder<HomeProductViewCubit, HomeProductViewState>(
              builder: (context, state) {
            if (state is HomeProductViewInitialState) {
              return const LinearProgressIndicator();
            } else if (state is HomeProductViewLoadedState) {
              List<Product> products = state.products;
              return RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: onrefresh,
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                "Offers & Deals",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Carousel(),
                          ],
                        ),
                      ),
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
                                "Popular Categories",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 4.0),
                              child: CategoryScrollCard(
                                imgCardList: HomePage.categoryImgcardList,
                                isNetworkImage: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text(
                            "New Products",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      sliverProductDisplay(products),
                      SliverToBoxAdapter(
                        child: BlocBuilder<HomeDataFetchedCubit,
                            HomeDataFetchState>(
                          builder: (context, state) {
                            if (state is HomeDataFetchInitialState) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 12.0, right: 12.0),
                                child: SizedBox(
                                  width: 10,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        enableFeedback: true,
                                        elevation:
                                            const MaterialStatePropertyAll(5),
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)))),
                                    onPressed: () {
                                      HomeServices.fetchRandomProducts(
                                          2, fetchtoken(), context);
                                    },
                                    child: const Text(
                                      "Load More",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              // return TextButton(
                              //   child: const Text('Load More'),
                              //   onPressed: () {
                              //
                              //   },
                              // );
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
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text("Unknown State"),
                ),
              );
            }
          }),
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
