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
        pagination: SwiperPagination(
          builder: SwiperPagination(
                  builder: SwiperCustomPagination(
                    builder: (BuildContext context, SwiperPluginConfig config) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: config.itemCount * 16,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: config.itemCount > 0
                                ? List.generate(
                                    config.itemCount,
                                    (index) => Container(
                                      margin: const EdgeInsets.all(4.0),
                                      width: 6.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == config.activeIndex
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  )
                                : [],
                          ),
                        ),
                      );
                    },
                  ),
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
