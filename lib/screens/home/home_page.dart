import 'package:flutter/material.dart';
import 'package:rental_app/Components/Carousel_widget.dart';
import 'package:rental_app/Components/category_scroll_card.dart';

class HomePage extends StatelessWidget {
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
    // [
    //   "card4",
    //   "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    // ],
    // [
    //   "card5",
    //   "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    // ],
    // [
    //   "card6",
    //   "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    // ],
    // [
    //   "card7",
    //   "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png"
    // ],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Good Morning",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  "Browse through catgeories 👀",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              CategoryScrollCard(
                imgCardList: categoryImgcardList,
                isNetworkImage: true,
              ),
              const Carousel(),
            ],
          ),
        ),
      ),
    );
  }
}
