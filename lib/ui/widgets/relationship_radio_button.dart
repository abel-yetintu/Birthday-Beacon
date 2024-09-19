import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class RelationshipRadioButton extends StatelessWidget {
  final Relationship relationship;
  final Relationship groupValue;
  final void Function(Relationship?) onChanged;
  const RelationshipRadioButton({super.key, required this.relationship, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RadioListTile<Relationship>(
      value: relationship,
      groupValue: groupValue,
      title: Text(relationship.name.capitalize()),
      tileColor: theme.colorScheme.primaryContainer.withOpacity(.2),
      dense: true,
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onChanged: onChanged,
    );
  }
}
