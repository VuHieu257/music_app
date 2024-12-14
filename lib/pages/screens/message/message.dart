import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/message/create_group/GroupCreationScreen.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../../widget_small/widget.dart';
import 'message_detail/message_detail..dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String formatTimestamp(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('hh:mm a').format(dateTime); // dd/MM/yyyy hh:mm AM/PM
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Styles.defaultPadding),
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
            child: Column(
              children: [
                SizedBox(
                  height: context.height * 0.02,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Search",
                      hintStyle: context.theme.textTheme.headlineSmall),
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                // StreamBuilder(
                //   stream: firestore
                //       .collection('chats')
                //       .where('participants',
                //           arrayContains: "hafqF9xuWgXLQ9keqCmembit2L43")
                //       .orderBy('lastTimestamp', descending: true)
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                //       return const Center(
                //           child: Text("Không có cuộc trò chuyện nào"));
                //     }
                //     var chatDocs = snapshot.data!.docs;
                //
                //     if (chatDocs.isEmpty) {
                //       return const Center(
                //           child: Text("Không có cuộc trò chuyện nào"));
                //     }
                //     return ListView.builder(
                //       itemCount: chatDocs.length,
                //       itemBuilder: (context, index) {
                //         var chat = chatDocs[index];
                //         var participants = chat['participants'] as List;
                //         String otherUserId = participants.firstWhere(
                //             (id) => id != "hafqF9xuWgXLQ9keqCmembit2L43");
                //         return FutureBuilder(
                //           future: firestore
                //               .collection('db_users')
                //               .doc(otherUserId)
                //               .get(),
                //           builder: (context,
                //               AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                //             if (!userSnapshot.hasData) {
                //               return const Center(
                //                 child: CircularProgressIndicator(),
                //               );
                //             }
                //             if (!userSnapshot.hasData ||
                //                 !userSnapshot.data!.exists) {
                //               return const Center(child: Text(""));
                //             }
                //             var userData = userSnapshot.data!.data()
                //                 as Map<String, dynamic>;
                //             String otherUserName = userData['displayName'];
                //             String formattedTimestamp =
                //                 chat['lastTimestamp'] != null
                //                     ? formatTimestamp(chat['lastTimestamp'])
                //                     : "No timestamp";
                //             return Slidable(
                //                 key: const ValueKey(0),
                //                 endActionPane: ActionPane(
                //                   motion: const ScrollMotion(),
                //                   dismissible:
                //                       DismissiblePane(onDismissed: () {}),
                //                   children: [
                //                     SlidableAction(
                //                       flex: 1,
                //                       // onPressed: (context) => customShowReportSheet(context),
                //                       onPressed: (context) =>
                //                           customShowBlockSheet(context),
                //                       foregroundColor: Colors.black,
                //                       icon: Icons.clear_all_sharp,
                //                       // borderRadius: BorderRadius.all(Radius.circular(50)),
                //                     ),
                //                     SlidableAction(
                //                       onPressed: (context) =>
                //                           customShowBottomSheet(context),
                //                       // backgroundColor: Color(0xFF0392CF),
                //                       foregroundColor: Colors.black,
                //                       icon: Icons.notifications,
                //                     ),
                //                     SlidableAction(
                //                       onPressed: (context) =>
                //                           doNothing(context, chat.id),
                //                       // backgroundColor: Color(0xFF0392CF),
                //                       foregroundColor: Colors.black,
                //                       icon: Icons.delete,
                //                     ),
                //                   ],
                //                 ),
                //                 child: _buildMessageTile(
                //                   otherUserName,
                //                   chat['lastMessage'],
                //                   formattedTimestamp,
                //                   () {
                //                     // Navigator.push(
                //                     //   context,
                //                     //   MaterialPageRoute(
                //                     //     builder: (context) => ChatScreen(
                //                     //       currentUserId: currentUserId,
                //                     //       name: otherUserName,
                //                     //       chatId: chat.id,
                //                     //       receiverId: otherUserId,
                //                     //       receiverName: otherUserName,
                //                     //     ),
                //                     //   ),
                //                     // );
                //                   },
                //                 ));
                //           },
                //         );
                //       },
                //     );
                //   },
                // ),
                SizedBox(
                  height: 500,
                  child: StreamBuilder(
                    stream: firestore
                        .collection('chats')
                        .where('participants',
                        arrayContains: "hafqF9xuWgXLQ9keqCmembit2L43")
                        .orderBy('lastTimestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("Không có cuộc trò chuyện nào"));
                      }

                      var chatDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: chatDocs.length,
                        itemBuilder: (context, index) {
                          var chat = chatDocs[index];
                          var participants = chat['participants'] as List;
                          String otherUserId = participants.firstWhere(
                                  (id) => id != "hafqF9xuWgXLQ9keqCmembit2L43");

                          return FutureBuilder(
                            future: firestore.collection('db_users').doc(otherUserId).get(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                                return const SizedBox.shrink(); // Không hiển thị gì nếu không có dữ liệu
                              }

                              var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                              String otherUserName = userData['displayName'] ?? "Unknown User";
                              String formattedTimestamp = chat['lastTimestamp'] != null
                                  ? formatTimestamp(chat['lastTimestamp'])
                                  : "No timestamp";

                              return Slidable(
                                key: ValueKey(chat.id),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => customShowBlockSheet(context),
                                      icon: Icons.block,
                                      label: "Chặn",
                                    ),
                                    SlidableAction(
                                      onPressed: (context) => customShowBottomSheet(context),
                                      icon: Icons.notifications,
                                      label: "Thông báo",
                                    ),
                                    SlidableAction(
                                      onPressed: (context) => doNothing(context, chat.id),
                                      icon: Icons.delete,
                                      label: "Xóa",
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: userData['profilePicture'] != null
                                        ? NetworkImage(userData['profilePicture'])
                                        : const AssetImage("assets/images/default_avatar.png")
                                    as ImageProvider,
                                  ),
                                  title: Text(otherUserName),
                                  subtitle: Text(chat['lastMessage'] ?? "Không có tin nhắn"),
                                  trailing: Text(formattedTimestamp),
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ChatScreen(
                                    //       currentUserId: "hafqF9xuWgXLQ9keqCmembit2L43",
                                    //       name: otherUserName,
                                    //       chatId: chat.id,
                                    //       receiverId: otherUserId,
                                    //       receiverName: otherUserName,
                                    //     ),
                                    //   ),
                                    // );
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

                SizedBox(
                  height: context.height * 0.8,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MessageDetail(chatID: "M3PKMeJ0qnCJdRuXmkUm",),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage(Asset.bgImageAvatar),
                                  ),
                                  SizedBox(
                                    width: context.width * 0.02,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Jane💕",
                                        style: context
                                            .theme.textTheme.headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      Text("Hello are you home?",
                                          style: context
                                              .theme.textTheme.titleMedium
                                              ?.copyWith(color: Styles.grey))
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("5mins",
                                          style: context
                                              .theme.textTheme.titleMedium),
                                      CircleAvatar(
                                        radius: 13,
                                        backgroundColor: Styles.blueIcon,
                                        child: Text("2",
                                            style: context
                                                .theme.textTheme.titleMedium
                                                ?.copyWith(
                                                    color: Styles.light)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile(
      String name, String message, String time, void Function()? onTap,
      [String? unreadCount]) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Stack(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                  Asset.bgImageAvatarUser), // Replace with your image assets
            ),
            const Positioned(
              top: 0,
              left: 0,
              child: CircleAvatar(
                radius: 7,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.green,
                ),
              ),
            ),
            if (unreadCount != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(unreadCount,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ),
              )
          ],
        ),
        title: Text(name),
        subtitle: Row(
          children: [
            Text(message),
            const SizedBox(
              width: 10,
            ),
            Text(time, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            unreadCount == null
                ? const Icon(Icons.check_circle, color: Colors.grey, size: 16)
                : const Icon(Icons.circle_outlined,
                    color: Colors.grey, size: 16),
          ],
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
