import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        itemCount: 10,
        autoplay: true,
        loop: true,
        autoplayDisableOnInteraction: true,
        containerHeight: 100,
        containerWidth: 100,
        scrollDirection: Axis.horizontal,
        pagination: const SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeSize: 8,
            size: 6,
            space: 4,
          ),
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                "data $index",
              ),
            ),
          );
        },
      ),
    );
  }
}
