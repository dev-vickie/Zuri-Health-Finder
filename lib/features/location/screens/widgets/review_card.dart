import 'package:flutter/material.dart';
import 'package:zuri_finder/models/hospital_details_model.dart';

class ReviewCard extends StatelessWidget {
  final Reviews reviews;
  const ReviewCard({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: reviews.authorAttribution?.photoUri != null
            ? CircleAvatar(
                backgroundImage:
                    NetworkImage(reviews.authorAttribution!.photoUri ?? ""),
              )
            : const Icon(
                Icons.person,
                size: 40,
                color: Colors.grey,
              ),
        title: Text(
          reviews.authorAttribution
                  ?.displayName ??
              'N/A',
        ),
        subtitle: Text(
          reviews.text?.text ?? 'N/A',
        ),
      ),
    );
  }
}
