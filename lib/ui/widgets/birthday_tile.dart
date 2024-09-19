import 'dart:io';
import 'package:birthday_beacon/core/utils/extensions.dart';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BirthdayTile extends StatelessWidget {
  final Birthday birthday;
  const BirthdayTile({super.key, required this.birthday});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * .01, horizontal: size.width * .02),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildImage(theme, size),
                    SizedBox(width: size.width * .02),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${birthday.firstName} ${birthday.lastName ?? ''}',
                            maxLines: 1,
                            style: theme.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          birthday.remainingDaystillBirthday() == 0
                              ? Text(
                                  'Turns ${birthday.calculateAge()} Today',
                                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  'Turns ${birthday.calculateNextAge()} on ${birthday.birthdate.getMonthAndDay()}',
                                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: size.width * .15,
                padding: EdgeInsets.symmetric(horizontal: size.width * .025),
                child: birthday.remainingDaystillBirthday() == 0
                    ? FaIcon(
                        FontAwesomeIcons.cakeCandles,
                        size: size.width * .07,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            birthday.remainingDaystillBirthday().toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            'Days',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _buildImage(ThemeData theme, Size size) {
    if (birthday.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(birthday.imagePath!),
          width: size.width * 0.12,
          height: size.height * .06,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size.width * 0.12,
            height: size.height * .06,
            decoration: BoxDecoration(
              color: birthday.color,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              birthday.initials,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: size.width * 0.12,
        height: size.height * .06,
        decoration: BoxDecoration(
          color: birthday.color,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          birthday.initials,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
