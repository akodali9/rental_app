import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/screens/category/category_page.dart';
import 'package:rental_app/screens/category/providers/category_provider.dart';
import 'package:rental_app/screens/category/providers/catgeory_fetched.dart';
import 'package:rental_app/screens/category/services/category_service.dart';

class CategoryScrollCard extends StatefulWidget {
  const CategoryScrollCard({
    super.key,
    required this.isNetworkImage,
    required this.imgCardList,
  });

  final List<List> imgCardList;
  final bool isNetworkImage;

  @override
  State<CategoryScrollCard> createState() => _CategoryScrollCardState();
}

class _CategoryScrollCardState extends State<CategoryScrollCard> {
  @override
  void initState() {
    super.initState();
  }

  String fetchtoken() {
    final userTokenCubit = context.read<UserTokenCubit>();

    final String userToken = userTokenCubit.state is UserTokenLoadedState
        ? (userTokenCubit.state as UserTokenLoadedState).token
        : 'no token';

    return userToken;
  }

  void handleBack() {
    context.read<CategoryCubit>().clearCategoryItems();
    context.read<CatgeoryFetched>().removeState();
    CategoryServices.clearCategoryHistory(context, fetchtoken());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 127,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imgCardList.length,
        itemBuilder: (context, index) => Center(
          child: Column(children: [
            // widget.isNetworkImage
            //     ? Image.network(
            //         widget.imgCardList[index][1],
            //       )
            //     : ClipRRect(
            //         borderRadius: BorderRadius.circular(50.0),
            //         child: Image.asset(
            //           widget.imgCardList[index][1],
            //         ),
            //       ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              child: ElevatedButton(
                style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 8.0)),
                  fixedSize: MaterialStatePropertyAll(Size(150, 110)),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => CategoryPage(
                          category: widget.imgCardList[index][0],
                        ),
                      ))
                      .then((value) => {handleBack()});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.imgCardList[index][2],
                      size: 50,
                      //color: widget.imgCardList[index][3],
                    ),
                    Text(
                      widget.imgCardList[index][0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // color: Theme.of(context).bannerTheme.backgroundColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
