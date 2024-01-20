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
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imgCardList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Container(
            height: 120,
            width: 120,
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.black12),
            child: InkWell(
              onTap: () {},
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    isNetworkImage
                        ? Image.network(
                            imgCardList[index][1],
                            height: 80,
                          )
                        : Image.asset(
                            imgCardList[index][1],
                            height: 80,
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
