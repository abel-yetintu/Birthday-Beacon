import 'package:birthday_beacon/core/enums/filter.dart';
import 'package:birthday_beacon/core/utils/extensions.dart';
import 'package:birthday_beacon/data/models/birthday.dart';
import 'package:birthday_beacon/providers/birthdays_notifier.dart';
import 'package:birthday_beacon/providers/providers.dart';
import 'package:birthday_beacon/providers/theme_notifier.dart';
import 'package:birthday_beacon/ui/widgets/birthday_tile.dart';
import 'package:birthday_beacon/ui/widgets/loading_birthday_tile.dart';
import 'package:birthday_beacon/ui/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Birthday Beacon'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
            icon: ref.watch(themeNotifierProvider) == ThemeMode.dark
                ? const FaIcon(FontAwesomeIcons.solidSun)
                : const FaIcon(FontAwesomeIcons.moon),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02, size.width * 0.05, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: Filter.values.map((filter) => FilterButton(filter: filter)).toList(),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: ref.watch(filteredBirthdaysProvider).when(
                    skipLoadingOnReload: true,
                    loading: () {
                      return ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return const LoadingBirthdayTile();
                        },
                      );
                    },
                    error: (error, stackTrace) => Center(
                      child: Text(
                        error.toString(),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    data: (data) {
                      if (data.isEmpty) {
                        return const Center(
                          child: Text(
                            "No birthdays yet. Add one to get started!",
                            maxLines: 1,
                          ),
                        );
                      }
                      return NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.direction == ScrollDirection.forward) {
                            ref.read(fabVisibilityProvider.notifier).update((visibility) => true);
                          } else if (notification.direction == ScrollDirection.reverse) {
                            ref.read(fabVisibilityProvider.notifier).update((visibility) => false);
                          }
                          return true;
                        },
                        child: GroupedListView(
                          elements: data,
                          groupBy: (birthday) => birthday.birthdate.month,
                          groupHeaderBuilder: (birthday) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: size.height * 0.01),
                              child: Text(
                                birthday.birthdate.getFullMonth(),
                                style: theme.textTheme.bodyLarge,
                              ),
                            );
                          },
                          itemComparator: (birthday1, birthday2) {
                            return birthday1.birthdate.day.compareTo(birthday2.birthdate.day);
                          },
                          itemBuilder: (context, birthday) {
                            return Container(
                              margin: EdgeInsets.only(bottom: size.height * .01),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      icon: FontAwesomeIcons.trash,
                                      onPressed: (context) {
                                        _showAlertDialog(theme, context, birthday, ref);
                                      },
                                    ),
                                  ],
                                ),
                                child: BirthdayTile(birthday: birthday),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: ref.watch(fabVisibilityProvider)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addBirthday');
              },
              child: const FaIcon(FontAwesomeIcons.plus),
            )
          : null,
    );
  }

  void _showAlertDialog(ThemeData theme, BuildContext context, Birthday birthday, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Birthday'),
          content: const Text('Are you sure you want to delete this birthday?'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(birthdaysNotifierProvider.notifier).deleteBirthday(birthday).then(
                  (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        content: Text(
                          result != 0 ? 'Birthday deleted!' : 'Ooops! Something went wrong',
                          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                    );
                  },
                );
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
