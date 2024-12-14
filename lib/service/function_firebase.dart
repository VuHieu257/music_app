import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> sendFriendRequest(
    {required String userId,
      required String friendId,
      required String nameUser,
      required String nameFriend,
      String? imgUrl,
      String? imaUrlFriend}) async {
  try {
    await _firestore
        .collection('friendRequests')
        .doc('${userId}_$friendId')
        .set({
      'senderId': userId,
      'receiverId': friendId,
      'nameReceiver': nameFriend,
      'nameSender': nameUser,
      'imageReceiver': imgUrl,
      'imageSender': imgUrl,
      'status': 'pending',
      'requestedAt': FieldValue.serverTimestamp(),
    });
    if (kDebugMode) {
      print("Friend request sent successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Failed to send friend request: $e");
    }
  }
}

Future<void> acceptFriendRequest(
    {required String requestId,
      required String userId,
      required String friendId,
      required String name,
      String? imgUrl,
      required String nameCurrent,
      String? imgCurrent}) async {
  try {
    // Update the request status to accepted
    await _firestore
        .collection('friendRequests')
        .doc(requestId)
        .update({'status': 'accepted'});

    // Add to the 'friends' collection for both users
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .set({
      'id': friendId,
      'name': name,
      'image': imgUrl,
      'addedAt': FieldValue.serverTimestamp(),
    });
    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .set({
      'id': userId,
      'name': nameCurrent,
      'image': imgCurrent,
      'addedAt': FieldValue.serverTimestamp(),
    });
    if (kDebugMode) {
      print("Friend request accepted and friend added successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Failed to accept friend request: $e");
    }
  }
}

Future<void> removeFriend(
    String userId, String friendId, String requestId) async {
  try {
    // Remove friend from the user's friend list
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .delete();

    // Remove the user from the friend's friend list
    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .delete();

    await _firestore.collection('friendRequests').doc(requestId).delete();

    if (kDebugMode) {
      print("Friend removed successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Failed to remove friend: $e");
    }
  }
}

void createNewChat(BuildContext context, String currentUserId,
    String otherUserId, String name) async {
  final chatQuery = await _firestore
      .collection('chats')
      .where('participants', arrayContains: currentUserId)
      .get();

  String chatId = "";
  bool chatExists = false;

  for (var doc in chatQuery.docs) {
    List participants = doc.data()['participants'];
    if (participants.contains(otherUserId)) {
      chatExists = true;
      chatId = doc.id;
      break;
    }
  }

  if (chatExists) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChatScreen(
    //       currentUserId: currentUserId,
    //       name: name,
    //       chatId: chatId,
    //       receiverId: otherUserId,
    //       receiverName: name,
    //     ),
    //   ),
    // );
  } else {
    final chatDocRef = _firestore.collection('chats').doc();

    await chatDocRef.set({
      'participants': [currentUserId, otherUserId],
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
    });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChatScreen(
    //       currentUserId: currentUserId,
    //       name: name,
    //       chatId: chatDocRef.id,
    //       receiverId: otherUserId,
    //       receiverName: name,
    //     ),
    //   ),
    // );
  }
}
Future<void> addUser(String userId, String name, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .doc(userId)
      .set({
    'name': name,
    'phone': userId,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}