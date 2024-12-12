import 'package:firebase_storage/firebase_storage.dart';

Future<String?> getMusicUrl(String fileName) async {
  try {
    Reference ref = FirebaseStorage.instance.ref().child('music/$fileName');
    String url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    print("Error getting URL: $e");
    return null;
  }
}
enum RepeatMode {
  none,
  one,
  all,
}