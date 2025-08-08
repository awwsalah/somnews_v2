import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 200,
              color: Colors.white,
            ),
            // Content placeholder
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, height: 18.0, color: Colors.white),
                  const SizedBox(height: 8.0),
                  Container(width: double.infinity, height: 18.0, color: Colors.white),
                  const SizedBox(height: 12.0),
                  Container(width: 150.0, height: 14.0, color: Colors.white),
                  const SizedBox(height: 8.0),
                  Container(width: 100.0, height: 14.0, color: Colors.white),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 80.0, height: 12.0, color: Colors.white),
                      Container(width: 80.0, height: 12.0, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
