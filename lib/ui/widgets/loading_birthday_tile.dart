import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingBirthdayTile extends StatelessWidget {
  const LoadingBirthdayTile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Skeletonizer(
      enabled: true,
      child: Card(
        margin: EdgeInsets.only(bottom: size.height * .01),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * .01, horizontal: size.width * .02),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  width: size.width * 0.12,
                  height: size.height * .06,
                ),
              ),
              SizedBox(width: size.width * .02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Full Name'),
                  Text(
                    'Date of the persons birthday',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
