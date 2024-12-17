import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../core/assets.dart';
import '../../core/colors/color.dart';

class FavoriteButton extends StatefulWidget {
  final String userId;
  final String songId;

  const FavoriteButton({
    super.key,
    required this.userId,
    required this.songId,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final doc = await FirebaseFirestore.instance.collection('db_user').doc(widget.userId).get();
    if (doc.exists && doc['favorites'] != null) {
      final favorites = List<String>.from(doc['favorites']);
      setState(() {
        isFavorite = favorites.contains(widget.songId);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final docRef = FirebaseFirestore.instance.collection('db_user').doc(widget.userId);
    final doc = await docRef.get();

    if (isFavorite) {
      // Xóa khỏi yêu thích
      await docRef.update({
        'favorites': FieldValue.arrayRemove([widget.songId])
      });
      setState(() {
        isFavorite = false;
      });
    } else {
      // Thêm vào yêu thích
      if (doc.exists) {
        await docRef.update({
          'favorites': FieldValue.arrayUnion([widget.songId])
        });
      } else {
        await docRef.set({
          'favorites': [widget.songId]
        });
      }
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: _toggleFavorite,
        ),
      //   const SizedBox(width: 5,),
      //   InkWell(
      //       onTap: () {
      //         showShareOptions(context);
      //       },
      //       child: Icon(Icons.share,
      //           color: context.theme.iconTheme.color)),
      ],
    );
  }
  void showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  width: context.width * 0.2,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Styles.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareOption(
                      context, Asset.iconImageShareUrl, "Copy url"),
                  _buildShareOption(
                      context, Asset.iconImageShareIntargram, "Instagram"),
                  _buildShareOption(
                      context, Asset.iconImageShareMess, "Messenger"),
                  _buildShareOption(
                      context, Asset.iconImageShareFb, "Facebook"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareOption(
                      context, Asset.iconImageShareIntargram, "Instagram"),
                  _buildShareOption(
                      context, Asset.iconImageShareMessSms, "Message"),
                  _buildShareOption(context, Asset.iconImageShareMore, "More"),
                  Container(), // Placeholder for empty space
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildShareOption(
      BuildContext context, String imagePath, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}