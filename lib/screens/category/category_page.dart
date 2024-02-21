import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Components/sliver_product_display.dart';
import 'package:rental_app/screens/category/providers/category_provider.dart';
import 'package:rental_app/screens/category/providers/catgeory_fetched.dart';
import 'package:rental_app/screens/category/services/category_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.category});
  final String category;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    CategoryServices.getCategory(context, widget.category, false, fetchtoken());
    context.read<CategoryCubit>().clearCategoryItems();
    context.read<CatgeoryFetched>().removeState();
    CategoryServices.clearCategoryHistory(context, fetchtoken());
  }

  String fetchtoken() {
    final userTokenCubit = context.read<UserTokenCubit>();

    final String userToken = userTokenCubit.state is UserTokenLoadedState
        ? (userTokenCubit.state as UserTokenLoadedState).token
        : 'no token';

    return userToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryIntialState) {
            return const LinearProgressIndicator();
          } else if (state is CategoryLoadedState) {
            final catProducts = state.categoryProducts;
            if (catProducts.isEmpty) {
              return const Center(
                child: Text(
                  "Cannot load category items\nTry again later 😊",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return CustomScrollView(
                slivers: [
                  sliverProductDisplay(catProducts),
                  SliverToBoxAdapter(
                    child: BlocBuilder<CatgeoryFetched, CatgeoryFetchedState>(
                      builder: (context, state) {
                        if (state is CatgeoryFetchedInitialState) {
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
                                                BorderRadius.circular(10.0)))),
                                onPressed: () {
                                  CategoryServices.getCategory(context,
                                      widget.category, true, fetchtoken());
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
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  )
                ],
              );
            }
          } else {
            return const Center(
              child: Text('Unkown State'),
            );
          }
        },
      ),
    );
  }
}
