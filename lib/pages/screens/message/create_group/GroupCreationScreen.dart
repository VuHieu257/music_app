import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../../service/function_firebase.dart';

class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({super.key});

  @override
  State<GroupCreationScreen> createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  void _showNewGroupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const NewGroupModal(),
        );
      },
    );
  }
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final Random _random = Random();
  List<Map<String, dynamic>> _randomUsers = [];
  @override
  void initState() {
    super.initState();
    _fetchRandomUsers();
  }
  Future<void> _fetchRandomUsers() async {
    try {
      // Lấy toàn bộ dữ liệu từ collection 'db_user'
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('db_user').get();

      if (snapshot.docs.isNotEmpty) {
        // Convert snapshot thành List
        List<Map<String, dynamic>> allUsers = snapshot.docs
            .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();

        // Chọn ngẫu nhiên 5 người dùng
        allUsers.shuffle(_random);
        setState(() {
          _randomUsers = allUsers.take(5).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Hủy',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        title: Text(
          'Tin nhắn mới',
          style: context.theme.textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.group_add, color: Colors.black),
              title: Text(
                'Tạo nhóm mới',
                style: context.theme.textTheme.headlineMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: context.theme.iconTheme.color),
              onTap: () {
                _showNewGroupModal(context);
              },
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            Text(
              'Gợi ý',
              style: context.theme.textTheme.headlineSmall,
            ),
            SizedBox(height: context.height * 0.01),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: _randomUsers.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : ListView.builder(
                      itemCount: _randomUsers.length,
                      itemBuilder: (context, index) {
                        final user = _randomUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                              user['profilePicture'] != null
                                  ? NetworkImage(
                                  user['profilePicture'])
                                  : const AssetImage(
                                  Asset.bgImageAvatarUser)
                              as ImageProvider,
                            ),
                            title: Text(
                              user['displayName'] ?? 'No Name',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            subtitle: Text(user['email'] ?? 'No Email'),
                            onTap: () {
                                  createNewChat(context,"$userID",
                                      user['id'], user['displayName'],"");
                              debugPrint("Tapped user: ${user['displayName']}");
                            },
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
class NewGroupModal extends StatefulWidget {
  const NewGroupModal({super.key});

  @override
  State<NewGroupModal> createState() => _NewGroupModalState();
}

class _NewGroupModalState extends State<NewGroupModal> {
  final Random _random = Random();

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _suggestedUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  List<Map<String, dynamic>> _selectedUsers = [];
  bool _isSearching = false; // Biến trạng thái tìm kiếm

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Hàm fetch toàn bộ người dùng từ Firestore
  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('db_user').get();

      List<Map<String, dynamic>> users = snapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      // Xáo trộn và lấy 3 người dùng ngẫu nhiên làm gợi ý
      users.shuffle(_random);

      setState(() {
        _allUsers = users;
        _suggestedUsers = users.take(3).toList();
        _filteredUsers = users; // Dùng cho tìm kiếm
      });
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  // Hàm xử lý tìm kiếm người dùng
  void _searchUser(String query) {
    setState(() {
      if (query.isEmpty) {
        _isSearching = false; // Không tìm kiếm -> hiện gợi ý
        _filteredUsers = _allUsers;
      } else {
        _isSearching = true; // Đang tìm kiếm -> ẩn gợi ý
        _filteredUsers = _allUsers
            .where((user) =>
            user['displayName'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Hàm chọn hoặc bỏ chọn người dùng
  void _toggleSelectUser(Map<String, dynamic> user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy', style: TextStyle(color: Colors.blue)),
              ),
              const Text('Nhóm mới', style: TextStyle(fontSize: 20)),
              TextButton(
                onPressed: () {
                  debugPrint('Selected Users: $_selectedUsers');
                },
                child: const Text('Tạo', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),

          // Thanh tìm kiếm
          TextField(
            onChanged: _searchUser,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Tìm kiếm người dùng',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _selectedUsers.map((user) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0,left: 8),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                            user['img'] != ""
                                ? NetworkImage(
                                user['img'])
                                : const AssetImage(
                                Asset.bgImageAvatarUser)
                            as ImageProvider,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _toggleSelectUser(user),
                              child: const CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        user['displayName'] ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gợi ý',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (!_isSearching) ...[
            ..._suggestedUsers.map((user) {
              return ListTile(
                leading:CircleAvatar(
                  backgroundImage:
                  user['img'] != ""
                      ? NetworkImage(
                      user['img'])
                      : const AssetImage(
                      Asset.bgImageAvatarUser)
                  as ImageProvider,
                ),
                title: Text(user['displayName'] ?? ''),
                trailing: Icon(
                  _selectedUsers.contains(user)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: _selectedUsers.contains(user) ? Colors.blue : null,
                ),
                onTap: () => _toggleSelectUser(user),
              );
            }),
          ],

          Visibility(
            visible: _isSearching,
            child: Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return ListTile(
                    leading:CircleAvatar(
                      backgroundImage:
                      user['img'] != ""
                          ? NetworkImage(
                          user['img'])
                          : const AssetImage(
                          Asset.bgImageAvatarUser)
                      as ImageProvider,
                    ),
                    title: Text(user['displayName'] ?? ''),
                    trailing: Icon(
                      _selectedUsers.contains(user)
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _selectedUsers.contains(user) ? Colors.blue : null,
                    ),
                    onTap: () => _toggleSelectUser(user),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class NewGroupModal extends StatefulWidget {
//   const NewGroupModal({super.key});
//
//   @override
//   State<NewGroupModal> createState() => _NewGroupModalState();
// }
//
// class _NewGroupModalState extends State<NewGroupModal> {
//   final Random _random = Random();
//
//   List<Map<String, dynamic>> _allUsers = [];
//   List<Map<String, dynamic>> _suggestedUsers = [];
//   List<Map<String, dynamic>> _filteredUsers = [];
//   List<Map<String, dynamic>> _selectedUsers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }
//
//   // Hàm fetch toàn bộ người dùng từ Firestore
//   Future<void> _fetchUsers() async {
//     try {
//       QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('db_user').get();
//
//       List<Map<String, dynamic>> users = snapshot.docs
//           .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
//           .toList();
//
//       // Xáo trộn và lấy 3 người dùng ngẫu nhiên làm gợi ý
//       users.shuffle(_random);
//
//       setState(() {
//         _allUsers = users;
//         _suggestedUsers = users.take(3).toList();
//         _filteredUsers = users; // Dùng cho tìm kiếm
//       });
//     } catch (e) {
//       debugPrint("Error fetching users: $e");
//     }
//   }
//
//   // Hàm xử lý tìm kiếm người dùng
//   void _searchUser(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredUsers = _allUsers;
//       } else {
//         _filteredUsers = _allUsers
//             .where((user) =>
//             user['displayName'].toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }
//
//   // Hàm chọn hoặc bỏ chọn người dùng
//   void _toggleSelectUser(Map<String, dynamic> user) {
//     setState(() {
//       if (_selectedUsers.contains(user)) {
//         _selectedUsers.remove(user);
//       } else {
//         _selectedUsers.add(user);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Hủy', style: TextStyle(color: Colors.blue)),
//               ),
//               const Text('Nhóm mới', style: TextStyle(fontSize: 20)),
//               TextButton(
//                 onPressed: () {
//                   debugPrint('Selected Users: $_selectedUsers');
//                 },
//                 child: const Text('Tạo', style: TextStyle(color: Colors.blue)),
//               ),
//             ],
//           ),
//
//           // Thanh tìm kiếm
//           TextField(
//             onChanged: _searchUser,
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.search),
//               hintText: 'Tìm kiếm người dùng',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: BorderSide.none,
//               ),
//               fillColor: Colors.grey[200],
//               filled: true,
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Hiển thị danh sách đã chọn
//           SizedBox(
//             height: 80,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: _selectedUsers.map((user) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Column(
//                     children: [
//                       Stack(
//                         children: [
//                           const CircleAvatar(
//                               radius: 20,
//                               backgroundImage:
//                               AssetImage('assets/images/avatar.png')),
//                           Positioned(
//                             top: 0,
//                             right: 0,
//                             child: GestureDetector(
//                               onTap: () => _toggleSelectUser(user),
//                               child: const CircleAvatar(
//                                 radius: 8,
//                                 backgroundColor: Colors.blue,
//                                 child: Icon(Icons.close,
//                                     color: Colors.white, size: 13),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         user['displayName'] ?? '',
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Gợi ý người dùng
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Gợi ý',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//           ),
//           ..._suggestedUsers.map((user) {
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundImage:
//                 user['profilePicture'] != null
//                     ? NetworkImage(
//                     user['profilePicture'])
//                     : const AssetImage(
//                     Asset.bgImageAvatarUser)
//                 as ImageProvider,
//               ),
//               title: Text(user['displayName'] ?? ''),
//               trailing: Icon(
//                 _selectedUsers.contains(user)
//                     ? Icons.check_circle
//                     : Icons.radio_button_unchecked,
//                 color: _selectedUsers.contains(user) ? Colors.blue : null,
//               ),
//               onTap: () => _toggleSelectUser(user),
//             );
//           }),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _filteredUsers.length,
//               itemBuilder: (context, index) {
//                 final user = _filteredUsers[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage:
//                     user['profilePicture'] != null
//                         ? NetworkImage(
//                         user['profilePicture'])
//                         : const AssetImage(
//                         Asset.bgImageAvatarUser)
//                     as ImageProvider,
//                   ),
//                   title: Text(user['displayName'] ?? ''),
//                   trailing: Icon(
//                     _selectedUsers.contains(user)
//                         ? Icons.check_circle
//                         : Icons.radio_button_unchecked,
//                     color: _selectedUsers.contains(user) ? Colors.blue : null,
//                   ),
//                   onTap: () => _toggleSelectUser(user),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
