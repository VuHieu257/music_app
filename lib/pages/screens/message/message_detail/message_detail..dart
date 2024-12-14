import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/auth_service.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/message/box_chat.dart';

class MessageDetail extends StatefulWidget {
  final String chatID;

  const MessageDetail({super.key, required this.chatID});

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  bool isAddStatus = false;
  final TextEditingController _messageController = TextEditingController();
  Set<String> selectedMessages = {};
  bool isSelecting = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AuthService().hideKeyBoard(),
      child: Scaffold(
        appBar: isSelecting
            ? AppBar(
                backgroundColor: Colors.blue,
                leading: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedMessages.clear();
                      isSelecting = false;
                    });
                  },
                ),
                title: Text('${selectedMessages.length} tin nhắn đã chọn',
                    style: context.theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _deleteSelectedMessages(widget.chatID);
                    },
                  ),
                ],
              )
            : AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Styles.blueIcon,
                  ),
                ),
                title: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(Asset.bgImageAvatar),
                    ),
                    SizedBox(
                      width: context.width * 0.02,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jane💕",
                          style: context.theme.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text("Hello are you home?",
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(color: Styles.grey))
                      ],
                    ),
                  ],
                ),
                actions: const [
                  Icon(
                    Icons.more_vert,
                    color: Styles.blueIcon,
                  )
                ],
              ),
        body: Padding(
          padding: EdgeInsets.all(Styles.defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _fireStore
                      .collection('chats')
                      .doc(widget.chatID)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var messages = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var messageData = messages[index];
                        bool isMe = messageData['senderId'] ==
                            "hafqF9xuWgXLQ9keqCmembit2L43";
                        String messageId = messageData.id;
                        bool isSelected = selectedMessages.contains(messageId);
                        return !isSelecting
                            ? Container(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.5)
                                    : Colors.transparent,
                                child: _buildChatRow(
                                  audioUrl: messageData['audioUrl'],
                                  chatID: widget.chatID,
                                  message: messageData['message'],
                                  img: List<String>.from(
                                      messageData['imageUrls'] ?? []),
                                  isMe: isMe,
                                  messageId: messageId,
                                ),
                              )
                            : ListTile(
                                leading: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedMessages.add(messageId);
                                      } else {
                                        selectedMessages.remove(messageId);
                                      }
                                    });
                                  },
                                ),
                                title: _buildChatRow(
                                  audioUrl: messageData['audioUrl'],
                                  chatID: widget.chatID,
                                  message: messageData['message'],
                                  img: List<String>.from(
                                      messageData['imageUrls'] ?? []),
                                  isMe: isMe,
                                  messageId: messageId,
                                ),
                                onTap: () {
                                  if (isSelecting) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedMessages.remove(messageId);
                                      } else {
                                        selectedMessages.add(messageId);
                                      }
                                    });
                                  }
                                },
                              );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 50,)
              // Center(
              //   child: Text(
              //     "13:45 PM",
              //     style: context.theme.textTheme.headlineSmall
              //         ?.copyWith(color: Styles.grey),
              //   ),
              // ),
              // Row(
              //   children: [
              //     const CircleAvatar(
              //       radius: 20,
              //       backgroundImage: AssetImage(Asset.bgImageAvatar),
              //     ),
              //     SizedBox(
              //       width: context.width * 0.02,
              //     ),
              //     Container(
              //         width: context.height * 0.3,
              //         margin: const EdgeInsets.only(top: 20),
              //         padding: const EdgeInsets.all(10),
              //         decoration: const BoxDecoration(
              //             color: Styles.greyLight,
              //             borderRadius: BorderRadius.all(Radius.circular(10))),
              //         child: Text("aaaaaaaaaaaaaaaaaaaa",
              //             style: context.theme.textTheme.headlineMedium)),
              //   ],
              // ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Container(
              //       width: context.height * 0.35,
              //       padding: const EdgeInsets.all(10),
              //       margin: const EdgeInsets.only(top: 20),
              //       decoration: const BoxDecoration(
              //           color: Styles.blueIcon,
              //           borderRadius: BorderRadius.all(Radius.circular(10))),
              //       child: Text("Jane💕aaaaaaaaaaaaaaaaaaaa",
              //           style: context.theme.textTheme.headlineMedium
              //               ?.copyWith(color: Styles.light))),
              // ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Container(
              //       width: context.height * 0.3,
              //       padding: const EdgeInsets.all(10),
              //       margin: const EdgeInsets.only(top: 20),
              //       decoration: const BoxDecoration(
              //           color: Styles.greyLight,
              //           borderRadius: BorderRadius.all(Radius.circular(10))),
              //       child: Column(
              //         children: [
              //           Row(
              //             children: [
              //               Container(
              //                 height: context.height * 0.07,
              //                 width: context.height * 0.07,
              //                 decoration: const BoxDecoration(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(10)),
              //                     image: DecorationImage(
              //                         image: AssetImage(
              //                             Asset.bgImageMusicDetail))),
              //               ),
              //               SizedBox(
              //                 width: context.width * 0.02,
              //               ),
              //               Column(
              //                 children: [
              //                   SizedBox(
              //                     width: context.width * 0.3,
              //                     child: Text("Bụi",
              //                         style: context
              //                             .theme.textTheme.headlineMedium
              //                             ?.copyWith(
              //                                 overflow: TextOverflow.ellipsis)),
              //                   ),
              //                   SizedBox(
              //                     width: context.width * 0.3,
              //                     child: Text("Mây trắng",
              //                         style: context
              //                             .theme.textTheme.headlineSmall
              //                             ?.copyWith(
              //                                 overflow: TextOverflow.ellipsis,
              //                                 color: Styles.grey)),
              //                   ),
              //                 ],
              //               )
              //             ],
              //           ),
              //           Container(
              //             alignment: Alignment.center,
              //             padding: const EdgeInsets.all(5),
              //             margin: const EdgeInsets.only(top: 10),
              //             decoration: const BoxDecoration(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(10)),
              //                 color: Styles.light),
              //             child: Text(
              //               "Hủy",
              //               style: context.theme.textTheme.headlineSmall,
              //             ),
              //           )
              //         ],
              //       )),
              // ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
          height: context.height * 0.1,
          width: context.width,
          color: Styles.light,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      isAddStatus = !isAddStatus;
                    });
                  },
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Styles.blueIcon,
                  )),
              const Spacer(),
              InkWell(
                onTap:_pickAndSendImages,
                child: const Icon(
                  Icons.camera_alt,
                  color: Styles.blueIcon,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.file_present,
                color: Styles.blueIcon,
              ),
              const Spacer(),
              SizedBox(
                width: context.width * 0.6,
                height: context.height * 0.06,
                child: TextField(
                  controller: _messageController,
                  onChanged: (value) {
                    setState(() {
                      _messageController.text = value;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: "Type your message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)))),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: _messageController.text.isNotEmpty
                        ? Styles.blueIcon
                        : Colors.grey,
                  ))
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: isAddStatus,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: context.height * 0.2,
            color: Styles.greyLight,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Styles.light,
                      child: Icon(
                        Icons.headphones,
                        size: 40,
                      ),
                    ),
                    Text(
                      "Cùng nghe",
                      style: context.theme.textTheme.headlineSmall,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List<String> imageUrls = [];

  void _sendMessage() async {
    String message = _messageController.text.trim();
    _messageController.clear();
    _messageController.text = '';

    // String currentUserId = widget.currentUserId;
    var messageRef = _fireStore
        .collection('chats')
        .doc(widget.chatID)
        .collection('messages')
        .doc();


    await messageRef.set({
      'senderId': "hafqF9xuWgXLQ9keqCmembit2L43",
      'receiverId': "user_demo",
      'message': message,
      'imageUrls': imageUrls,
      // 'audioUrl': audioUrl ?? "",
      'audioUrl': "",
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _fireStore.collection('chats').doc(widget.chatID).update({
      'lastMessage': message.isNotEmpty ? message : (imageUrls.isNotEmpty ? "Đã gửi ảnh" : ""),
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }
  // void _sendMessage({List<String> imageUrls = const []}) async {
  //   String message = _messageController.text.trim();
  //   _messageController.clear();
  //
  //   var messageRef = _fireStore
  //       .collection('chats')
  //       .doc(widget.chatID)
  //       .collection('messages')
  //       .doc();
  //
  //   await messageRef.set({
  //     'senderId': "hafqF9xuWgXLQ9keqCmembit2L43",
  //     'receiverId': "user_demo",
  //     'message': message,
  //     'imageUrls': imageUrls,
  //     'audioUrl': "",
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  //
  //   await _fireStore.collection('chats').doc(widget.chatID).update({
  //     'lastMessage': message.isNotEmpty ? message : (imageUrls.isNotEmpty ? "Đã gửi ảnh" : ""),
  //     'lastTimestamp': FieldValue.serverTimestamp(),
  //   });
  // }
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickAndSendImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles == null || pickedFiles.isEmpty) return;

      for (XFile file in pickedFiles) {
        String imageUrl = await _uploadImage(File(file.path));
      setState(() {
        imageUrls.add(imageUrl);
      });}

      _sendMessage();
    } catch (e) {
      print("Error picking or uploading images: $e");
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('images').child(fileName);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
      rethrow;
    }
  }
  Widget _buildChatRow(
      {required String audioUrl,
      required String message,
      required String chatID,
      required List<dynamic> img,
      required bool isMe,
      required String messageId}) {
    return GestureDetector(
        onLongPress: () {
          _showDeleteMessageOptions(context, chatID, messageId, message);
        },
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe)
              const CircleAvatar(
                backgroundImage: AssetImage(Asset.bgImageAvatar),
              ),
            SizedBox(
              child: ChatBubble(
                isPlaying: false,
                onPressed: () {},
                message: message,
                img: img,
                isMe: isMe,
                urlVoice: audioUrl,
              ),
            ),
          ],
        ));
  }

  void _showDeleteMessageOptions(BuildContext context, String chatID,
      String messageId, String messageData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tùy chọn tin nhắn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(selectedMessages.isNotEmpty
                    ? 'Xóa ${selectedMessages.length} tin nhắn'
                    : 'Xóa tin nhắn'),
                onTap: () {
                  if (selectedMessages.isNotEmpty) {
                    _deleteSelectedMessages(chatID);
                  } else {
                    print(messageId);
                    _deleteMessage(chatID, messageId);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.checklist_outlined, color: Colors.blue),
                title: const Text('Chọn nhiều tin nhắn'),
                onTap: () {
                  setState(() {
                    isSelecting = true;
                  });
                  Navigator.pop(context);
                },
              ),
              if (selectedMessages.isEmpty)
                ListTile(
                  leading: const Icon(Icons.copy, color: Colors.blue),
                  title: const Text('Sao chép tin nhắn'),
                  onTap: () {
                    // Clipboard.setData(ClipboardData(text: messageData));
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _deleteSelectedMessages(String chatID) {
    for (var messageId in selectedMessages) {
      _fireStore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .doc(messageId)
          .delete();
    }
    setState(() {
      selectedMessages.clear();
      isSelecting = false;
    });
  }

  void _deleteMessage(String chatID, String messageId) {
    _fireStore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
