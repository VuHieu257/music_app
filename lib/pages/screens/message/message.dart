import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:music_app/auth_service.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/message/create_group/GroupCreationScreen.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../../widget_small/widget.dart';
import 'message_detail/message_detail..dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime); // dd/MM/yyyy hh:mm AM/PM
  }
  final user = FirebaseAuth.instance.currentUser?.uid;
  String _searchKeyword = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AuthService().hideKeyBoard(),
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
            "Messages",
            style: context.theme.textTheme.headlineLarge?.copyWith(
                color: Styles.blueIcon,
                fontWeight: FontWeight.bold,
                fontSize: 26),
          )),
          actions: [
            InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupCreationScreen(),
                    )),
                child: const Icon(
                  Icons.edit_note_outlined,
                  size: 30,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Styles.defaultPadding),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Search",
                    hintStyle: context.theme.textTheme.headlineSmall,
                  ),
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                SizedBox(
                  height: context.height * 0.8,
                  child: StreamBuilder(
                    stream: firestore
                        .collection('chats')
                        .where('participants', arrayContains: user)
                        .orderBy('lastTimestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("There are no conversations"),
                        );
                      }

                      var chatDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: chatDocs.length,
                        itemBuilder: (context, index) {
                          var chat = chatDocs[index];
                          var participants = chat['participants'] as List;
                          String otherUserId =
                              participants.firstWhere((id) => id != user);

                          return FutureBuilder(
                            future: firestore
                                .collection('db_user')
                                .doc(otherUserId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<
                                        DocumentSnapshot<Map<String, dynamic>>>
                                    userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!userSnapshot.hasData ||
                                  !(userSnapshot.data?.exists ?? false)) {
                                return const SizedBox.shrink();
                              }

                              var userData = userSnapshot.data!.data()!;
                              String otherUserName =
                                  userData['displayName']?.toLowerCase() ??
                                      "Unknown User";

                              // Lọc theo từ khóa tìm kiếm
                              if (_searchKeyword.isNotEmpty &&
                                  !otherUserName
                                      .contains(_searchKeyword.toLowerCase())) {
                                return const SizedBox.shrink();
                              }

                              String imgOther = userData['img'] ?? "";
                              String formattedTimestamp =
                                  chat['lastTimestamp'] != null
                                      ? formatTimestamp(chat['lastTimestamp'])
                                      : "No timestamp";

                              return Slidable(
                                key: ValueKey(chat.id),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) =>
                                          customShowBottomSheet(context),
                                      icon: Icons.notifications,
                                      label: "Notification",
                                    ),
                                    SlidableAction(
                                      onPressed: (context) =>
                                          doNothing(context, chat.id),
                                      icon: Icons.delete,
                                      label: "Xóa",
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        userData['profilePicture'] != null
                                            ? NetworkImage(
                                                userData['profilePicture'])
                                            : const AssetImage(
                                                    Asset.bgImageAvatarUser)
                                                as ImageProvider,
                                  ),
                                  title: Text(otherUserName),
                                  subtitle: Text(
                                      chat['lastMessage'] ?? "No messages",
                                      style: context.theme.textTheme.titleMedium
                                          ?.copyWith(color: Styles.grey)),
                                  trailing: Text(formattedTimestamp),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MessageDetail(
                                          chatID: chat.id,
                                          currentUserId: "$user",
                                          imgOther: imgOther,
                                          name: otherUserName,
                                          receiverId: otherUserId,
                                          receiverName: otherUserName,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doNothing(BuildContext context, String messageId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    var messages = await firestore
        .collection('chats')
        .doc(messageId)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await firestore
          .collection('chats')
          .doc(messageId)
          .collection('messages')
          .doc(doc.id)
          .delete();
    }

    await firestore.collection('chats').doc(messageId).delete();

    Navigator.pop(context);
  }
}
