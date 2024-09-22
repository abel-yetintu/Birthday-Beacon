import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotificationService {
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

  Future<void> init() async {
    await _awesomeNotifications.initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'birthday_reminders_channel',
          channelName: 'Birthday Reminders',
          channelDescription: null,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
    );
    bool isAllowedToSendNotifications = await _awesomeNotifications.isNotificationAllowed();
    if (!isAllowedToSendNotifications) {
      await _awesomeNotifications.requestPermissionToSendNotifications();
    }

    // set listeners
    await _awesomeNotifications.setListeners(
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationCreatedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  Future<void> createBirthdayReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime notificationSchedule,
  }) async {
    _awesomeNotifications.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'birthday_reminders_channel',
        category: NotificationCategory.Reminder,
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        month: notificationSchedule.month,
        day: notificationSchedule.day,
        hour: notificationSchedule.hour,
        minute: notificationSchedule.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> removeBirthdayReminderNotification(int notificationID) async {
    await _awesomeNotifications.cancel(notificationID);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification with ID: ${receivedNotification.id} created on ${receivedNotification.channelKey}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification with ID: ${receivedNotification.id} Displayed from ${receivedNotification.channelKey}');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    print('Notification with ID: ${receivedAction.id} Dismissed');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    print('Notification with ID: ${receivedAction.id} action recieved');
  }
}
