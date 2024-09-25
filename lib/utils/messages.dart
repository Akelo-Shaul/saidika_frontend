import 'package:intl/intl.dart';
class Messages{
  String message;
  DateTime time;
  bool isSentByMe;
  bool isDelivered;
  bool isRead;

  Messages({
    required this.message,
    required this.time,
    required this.isDelivered,
    required this.isRead,
    required this.isSentByMe,
  });


}