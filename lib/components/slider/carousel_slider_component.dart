import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_market_app/models/ui_models/carousel_slider_model.dart';
import 'package:flutter/material.dart';

///CarouselSlider
CarouselSlider carouselSliderMethod() {
  return CarouselSlider(
    items: carouselSliderModel.map((carouselModelValue) {
      return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                  carouselModelValue.imageUrl.toString()),
            ),
          ),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.black38,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      carouselModelValue.title.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ))),
        ),
      );
    }).toList(),
    options: CarouselOptions(
      autoPlay: true,
      aspectRatio: 16 / 9,
      initialPage: 0,
    ),
  );
}
