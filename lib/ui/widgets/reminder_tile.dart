import 'package:flutter/material.dart';

class ReminderTile extends StatelessWidget {
  final String reminderType;
  final bool value;
  final void Function(bool)? onChanged;
  const ReminderTile({super.key, required this.reminderType, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: size.height * 0.01),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                reminderType,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
