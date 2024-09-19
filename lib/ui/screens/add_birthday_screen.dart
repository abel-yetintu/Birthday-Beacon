import 'dart:io';
import 'package:birthday_beacon/controllers/add_birthday_screen_controller.dart';
import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/core/utils/extensions.dart';
import 'package:birthday_beacon/data/models/state/add_birthday_screen_state.dart';
import 'package:birthday_beacon/providers/providers.dart';
import 'package:birthday_beacon/ui/widgets/relationship_radio_button.dart';
import 'package:birthday_beacon/ui/widgets/reminder_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddBirthdayScreen extends ConsumerWidget {
  const AddBirthdayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final addBirthdayScreenState = ref.watch(addBirthdayScreenControllerProvider);
    final addBirthdayScreenController = ref.read(addBirthdayScreenControllerProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Birthday'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02, size.width * 0.05, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImage(context, ref, addBirthdayScreenState, addBirthdayScreenController),
                  SizedBox(width: size.width * .02),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                      child: Column(
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onTapOutside: (e) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              label: Text(
                                'First Name',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                            onChanged: (value) {
                              addBirthdayScreenController.setFirstName(value);
                            },
                          ),
                          SizedBox(height: size.height * .01),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onTapOutside: (e) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              label: Text(
                                'Last Name',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                            onChanged: (value) {
                              addBirthdayScreenController.setLastName(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * .02),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDatePicker(context, addBirthdayScreenController);
                  },
                  label: Text(addBirthdayScreenState.birthdate?.getMonthDayYear() ?? 'Select Birthday'),
                  icon: const FaIcon(FontAwesomeIcons.calendar),
                  iconAlignment: IconAlignment.end,
                ),
              ),
              SizedBox(height: size.height * .02),
              Text(
                'Relationship',
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: size.height * .02),
              _buildRelationshipRadioGroup(addBirthdayScreenController, size, addBirthdayScreenState),
              SizedBox(height: size.height * .02),
              Text(
                'Reminders',
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: size.height * .02),
              _buildReminders(addBirthdayScreenController, addBirthdayScreenState),
              _buildAddButton(context, size, ref, addBirthdayScreenController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    Size size,
    WidgetRef ref,
    AddBirthdayScreenController addBirthdayScreenController,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      width: double.infinity,
      child: FilledButton(
        onPressed: () async {
          if (ref.read(addBirthdayScreenControllerProvider).firstName == null ||
              ref.read(addBirthdayScreenControllerProvider).birthdate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                content: Text(
                  'First name and birthday must be provided.',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            );
          } else {
            final result = await addBirthdayScreenController.addBirthday();
            if (result != 0) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ooops! Something went wrong.'),
                ),
              );
            }
          }
        },
        child: const Text('Add'),
      ),
    );
  }

  _showDatePicker(BuildContext context, AddBirthdayScreenController addBirthdayScreenController) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        addBirthdayScreenController.setBirthDate(value);
      }
    });
  }

  _buildImage(
    BuildContext context,
    WidgetRef ref,
    AddBirthdayScreenState addBirthdayScreenState,
    AddBirthdayScreenController addBirthdayScreenController,
  ) {
    final size = MediaQuery.of(context).size;
    final tempImagePath = addBirthdayScreenState.tempImagePath;
    return GestureDetector(
      onTap: () {
        ref.read(imagePickerServiceProvider).pickImageFromGallery().then(
          (value) {
            addBirthdayScreenController.setImage(value);
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: tempImagePath != null
            ? Image.file(
                File(tempImagePath),
                width: size.width * 0.3,
                height: size.height * .15,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/profile_icon.jpg',
                width: size.width * 0.3,
                height: size.height * .15,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildReminders(
    AddBirthdayScreenController addBirthdayScreenController,
    AddBirthdayScreenState addBirthdayScreenState,
  ) {
    return Column(
      children: [
        ReminderTile(
          reminderType: 'On birthday',
          value: addBirthdayScreenState.notifyOnBirthday,
          onChanged: (value) {
            addBirthdayScreenController.changeNotifyOnBirthday(value);
          },
        ),
        ReminderTile(
          reminderType: 'One day before birthday',
          value: addBirthdayScreenState.notifyOneDayBeforeBirthday,
          onChanged: (value) {
            addBirthdayScreenController.changeNotifyOneDayBeforeBirthday(value);
          },
        ),
        ReminderTile(
          reminderType: 'Two days before birthday',
          value: addBirthdayScreenState.notifyTwoDaysBeforeBirthday,
          onChanged: (value) {
            addBirthdayScreenController.changeNotifiyTwoDaysBeforeBirthday(value);
          },
        ),
        ReminderTile(
          reminderType: 'One week before bithday',
          value: addBirthdayScreenState.notifyOneWeekBeforeBirthday,
          onChanged: (value) {
            addBirthdayScreenController.changeNotifiyOneWeekBeforeBirthday(value);
          },
        ),
      ],
    );
  }

  Widget _buildRelationshipRadioGroup(
    AddBirthdayScreenController addBirthdayScreenController,
    Size size,
    AddBirthdayScreenState addBirthdayScreenState,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.family,
                groupValue: addBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  addBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
            SizedBox(width: size.width * .02),
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.friend,
                groupValue: addBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  addBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * .01),
        Row(
          children: [
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.work,
                groupValue: addBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  addBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
            SizedBox(width: size.width * .02),
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.other,
                groupValue: addBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  addBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
