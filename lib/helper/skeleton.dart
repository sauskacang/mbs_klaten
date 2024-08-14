import 'package:android_smartscholl/helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(16.6 / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(16.6))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class CustomShimmer extends StatelessWidget {
  final double height;
  final double width;

  const CustomShimmer({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kPrimaryColor,
      highlightColor: const Color.fromARGB(255, 0, 0, 0),
      child: Skeleton(
        height: height,
        width: width,
      ),
    );
  }
}
