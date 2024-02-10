import 'package:flutter/material.dart';

class CategoryScrollCard extends StatelessWidget {
  const CategoryScrollCard({
    super.key,
    required this.isNetworkImage,
    required this.imgCardList,
  });

  final List<List<String>> imgCardList;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imgCardList.length,
        itemBuilder: (context, index) => Center(
          child: Container(
            width: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(double.infinity),
            ),
            child: InkWell(
              onTap: () {},
              child: Column(children: [
                isNetworkImage
                    ? Image.network(
                        imgCardList[index][1],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          imgCardList[index][1],
                        ),
                      ),
                Text(
                  imgCardList[index][0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
