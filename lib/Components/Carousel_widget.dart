import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/screens/home/providers/offers_cubit.dart';

class OfferCarousel extends StatefulWidget {
  const OfferCarousel({super.key});

  @override
  State<OfferCarousel> createState() => _OfferCarouselState();
}

class _OfferCarouselState extends State<OfferCarousel> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OffersCubit, OfferState>(builder: (context, state) {
      if (state is OfferInitialState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is OfferLoadedState) {
        final offersList = state.offerList;
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          width: MediaQuery.of(context).size.width,
          child: Swiper(
            itemCount: offersList.length,
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
              return Image.memory(
                offersList[index].image,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      } else {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: Text("Cannot Load Offers right now."),
          ),
        );
      }
    });
  }
}
