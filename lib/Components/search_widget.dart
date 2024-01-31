import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';
import 'package:rental_app/screens/search/providers/searched_products_cubit.dart';
import 'package:rental_app/screens/search/services/search_service.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget(
      {super.key,
      required this.textEditingController,
      required this.searchFocusNode});
  final TextEditingController textEditingController;
  final FocusNode searchFocusNode;
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String searchValue = "";
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.searchFocusNode,
      controller: widget.textEditingController,
      onChanged: (value) {
        setState(() {
          searchValue = value;
        });
      },
      onEditingComplete: () async {
        String query = widget.textEditingController.text;
        if (query != "") {
          await SearchService.productSearchCall(context, query);
        } else {
          showSnackbar(context, "Please enter in search bar");
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchValue != ""
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(
                    () {
                      widget.textEditingController.clear();
                      searchValue = "";
                      final SearchedProductCubit searchedProductCubit =
                          context.read<SearchedProductCubit>();
                      searchedProductCubit.removeSearchedProducts();
                    },
                  );
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
