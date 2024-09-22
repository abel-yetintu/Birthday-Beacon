import 'dart:io';
import 'package:birthday_beacon/controllers/edit_birthday_screen_controller.dart';
import 'package:birthday_beacon/core/enums/relationship.dart';
import 'package:birthday_beacon/core/utils/extensions.dart';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:birthday_beacon/providers/providers.dart';
import 'package:birthday_beacon/ui/widgets/relationship_radio_button.dart';
import 'package:birthday_beacon/ui/widgets/reminder_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditBirthdayScreen extends ConsumerStatefulWidget {
  final Birthday birthday;
  const EditBirthdayScreen({super.key, required this.birthday});

  @override
  ConsumerState<EditBirthdayScreen> createState() => _EditBirthdayScreenState();
}

class _EditBirthdayScreenState extends ConsumerState<EditBirthdayScreen> {
  late TextEditingController _firstNameTextEditingController;
  late TextEditingController _lastNameTextEditingController;

  @override
  void initState() {
    super.initState();
    _firstNameTextEditingController = TextEditingController();
    _lastNameTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final editBirthdayScreenState = ref.watch(editBirthdayScreenControllerProvider(widget.birthday));
    _firstNameTextEditingController.text = editBirthdayScreenState.firstName;
    if (editBirthdayScreenState.lastName != null) {
      _lastNameTextEditingController.text = editBirthdayScreenState.lastName!;
    }
    final editBirthdayScreenController = ref.watch(editBirthdayScreenControllerProvider(widget.birthday).notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Birthday'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02, size.width * 0.05, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildImage(context, ref, editBirthdayScreenState, editBirthdayScreenController),
                        SizedBox(width: size.width * .02),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _firstNameTextEditingController,
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
                                    editBirthdayScreenController.setFirstName(value);
                                  },
                                ),
                                SizedBox(height: size.height * .01),
                                TextField(
                                  controller: _lastNameTextEditingController,
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
                                    editBirthdayScreenController.setLastName(value);
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
                          _showDatePicker(context, editBirthdayScreenController);
                        },
                        label: Text(editBirthdayScreenState.birthdate.getMonthDayYear()),
                        icon: const FaIcon(FontAwesomeIcons.calendar),
                        iconAlignment: IconAlignment.end,
                      ),
                    ),
                    SizedBox(height: size.height * .02),
                    _buildRelationshipRadioGroup(size, theme, editBirthdayScreenState, editBirthdayScreenController),
                    SizedBox(height: size.height * .02),
                    _buildReminders(context, size, theme, editBirthdayScreenState, editBirthdayScreenController),
                  ],
                ),
              ),
            ),
            _buildSaveButton(context, size, ref, editBirthdayScreenState, editBirthdayScreenController),
          ],
        ),
      ),
    );
  }

  _showDatePicker(BuildContext context, EditBirthdayScreenController editBirthdayScreenController) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        editBirthdayScreenController.setBirthDate(value);
      }
    });
  }

  _showTimePicker(BuildContext context, EditBirthdayScreenController editBirthdayScreenController) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
      if (value != null) {
        editBirthdayScreenController.setReminderTime(value);
      }
    });
  }

  _showBottomSheet(
    BuildContext ctx,
    WidgetRef ref,
    Birthday editBirthdayScreenState,
    EditBirthdayScreenController editBirthdayScreenController,
  ) {
    final size = MediaQuery.of(ctx).size;
    showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.025),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(imagePickerServiceProvider).pickImageFromGallery().then(
                      (value) {
                        editBirthdayScreenController.setImage(value);
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.image),
                      SizedBox(width: size.width * 0.02),
                      const Text('Pick a photo'),
                    ],
                  ),
                ),
                if (editBirthdayScreenState.imagePath != null)
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        editBirthdayScreenController.removeImage();
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.trash),
                          SizedBox(width: size.width * 0.02),
                          const Text('Remove photo'),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
        });
  }

  _buildImage(
    BuildContext context,
    WidgetRef ref,
    Birthday editBirthdayScreenState,
    EditBirthdayScreenController editBirthdayScreenController,
  ) {
    final size = MediaQuery.of(context).size;
    final imagePath = editBirthdayScreenState.imagePath;
    return GestureDetector(
      onTap: () {
        _showBottomSheet(context, ref, editBirthdayScreenState, editBirthdayScreenController);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: imagePath != null
            ? Image.file(
                File(imagePath),
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

  Widget _buildRelationshipRadioGroup(
      Size size, ThemeData theme, Birthday editBirthdayScreenState, EditBirthdayScreenController editBirthdayScreenController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship',
          style: theme.textTheme.bodyLarge,
        ),
        SizedBox(height: size.height * .02),
        Row(
          children: [
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.family,
                groupValue: editBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  editBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
            SizedBox(width: size.width * .02),
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.friend,
                groupValue: editBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  editBirthdayScreenController.changeRelationship(relationship!);
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
                groupValue: editBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  editBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
            SizedBox(width: size.width * .02),
            Expanded(
              child: RelationshipRadioButton(
                relationship: Relationship.other,
                groupValue: editBirthdayScreenState.relationship,
                onChanged: (relationship) {
                  editBirthdayScreenController.changeRelationship(relationship!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminders(
    BuildContext context,
    Size size,
    ThemeData theme,
    Birthday editBirthdayScreenState,
    EditBirthdayScreenController editBirthdayScreenController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminders',
          style: theme.textTheme.bodyLarge,
        ),
        SizedBox(height: size.height * .02),
        ReminderTile(
          reminderType: 'On birthday',
          value: editBirthdayScreenState.notifyOnBirthday,
          onChanged: (value) {
            editBirthdayScreenController.changeNotifyOnBirthday(value);
          },
        ),
        ReminderTile(
          reminderType: 'One day before birthday',
          value: editBirthdayScreenState.notifyOneDayBeforeBirthday,
          onChanged: (value) {
            editBirthdayScreenController.changeNotifyOneDayBeforeBirthday(value);
          },
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _showTimePicker(context, editBirthdayScreenController);
            },
            label: Text(
              TimeOfDay(
                hour: editBirthdayScreenState.reminderHour,
                minute: editBirthdayScreenState.reminderMinute,
              ).format(context),
            ),
            icon: const FaIcon(FontAwesomeIcons.clock),
            iconAlignment: IconAlignment.end,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    Size size,
    WidgetRef ref,
    Birthday editBirthdayScreenState,
    EditBirthdayScreenController editBirthdayScreenController,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.01),
      width: double.infinity,
      child: FilledButton(
        onPressed: () async {
          if (editBirthdayScreenState.firstName == '') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                content: Text(
                  'First name must be provided.',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            );
          } else {
            final result = await editBirthdayScreenController.editBirthday(widget.birthday);
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
        child: const Text('Save'),
      ),
    );
  }
}
