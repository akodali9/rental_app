import 'package:flutter/material.dart';
import 'package:rental_app/screens/home/Components/Carousel_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routename = '/home';

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
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Carousel(),
              Text(
                "Heading",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
