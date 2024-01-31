import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Components/search_widget.dart';
import 'package:rental_app/Components/sliver_product_display.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/search/providers/searched_products_cubit.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  TextEditingController textEditingController = TextEditingController();
  String searchQuery = "";

  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Added a listener to focus on the TextFormField when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 1,
        scrolledUnderElevation: 20,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () {
              final SearchedProductCubit searchedProductCubit =
                  context.read<SearchedProductCubit>();
              searchedProductCubit.removeSearchedProducts();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SearchWidget(
            searchFocusNode: searchFocusNode,
            textEditingController: textEditingController,
          ),
        ),
      ),
      body: BlocBuilder<SearchedProductCubit, SearchedProductState>(
        builder: (context, state) {
          if (state is SearchedProductInititalState) {
            return const Center(
              child: Text('Search your preffered products'),
            );
          } else if (state is SearchedProductloadingState) {
            return const LinearProgressIndicator();
          } else if (state is SearchedProductLoadedState) {
            List<Product> searchedProducts = state.searchedProducts;
            if (searchedProducts == []) {
              return const Center(
              child: Text('No product has been found!'),
            ); 
            } else {
              return CustomScrollView(
                slivers: [
                  sliverProductDisplay(searchedProducts),
                ],
              );
            }
          } else {
            return const Center(
              child: Text('unknown state'),
            );
          }
        },
      ),
    );
  }
}
