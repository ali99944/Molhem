import 'dart:convert';
import 'package:http/http.dart' as http;

Future endChildSessionTime({
  required String body,
  required String title,
  required String token
}) async {
  String _key = 'AAAAjvqkaOk:APA91bH2LcQdsGyyByyfxSf-wBrvrxuqUMnbWtFn0oQVE9tEF7H1TpNxOgx9haft7Lt-GR0Qxw5nG-rWTrTRyeT5DsVqOgDOsDxfsTJIgcYUinpDNhP5v45_lSG_TTuFPy7QKVGCJlaT';
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_key',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          "to": token,
          'data':{
            'session-control': true
          }
        },
      ),
    );
    print('done');
  } catch (e) {
    print("error push notification");
  }
}