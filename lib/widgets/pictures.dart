import 'package:flutter/material.dart';

class Pictures extends StatelessWidget {
  final List<String> images;

  const Pictures({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.asset(images[index], fit: BoxFit.cover);
      },
    );
  }
}
