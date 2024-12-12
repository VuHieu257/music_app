import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/colors/color.dart';
import '../../../widget_small/custom_button.dart';
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List<Package> packages = [
    Package(title: 'Gói phổ biến', month: '1 tháng', price: '49,000', isSelected: true),
    Package(title: 'Gói tiết kiệm', month: '6 tháng', price: '49,000', isSelected: false),
    Package(title: 'Gói tiện lợi', month: '12 tháng', price: '49,000', isSelected: false),
  ];
  void _onCardTap(int index) {
    setState(() {
      for (int i = 0; i < packages.length; i++) {
        packages[i].isSelected = i == index;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
        title: Text(
          'Premium',
          style: context.theme.textTheme.headlineLarge?.copyWith(
            color: Styles.accent
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Toàn bộ đặc quyền cùng kho\nnhạc Premium',
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
                    // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                  SizedBox(
                    width: context.width,
                    height: context.height*0.16,
                    child: ListView.builder(
                      itemCount: packages.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _onCardTap(index),
                          child: PremiumPackageCard(
                            title: packages[index].title,
                            month: packages[index].month,
                            price: packages[index].price,
                            isSelected: packages[index].isSelected,
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  'Đặc quyền Premium',
                  style: context.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 8),
                const PremiumFeature(icon: Icons.music_note, text: 'Nghe và tải toàn bộ bài hát'),
               const Divider(),
                const  PremiumFeature(icon: Icons.block, text: 'Loại bỏ quảng cáo'),
                const Divider(),
                const PremiumFeature(icon: Icons.cloud_download, text: 'Lưu trữ nhạc không giới hạn'),
                const Divider(),
                const PremiumFeature(icon: Icons.format_indent_decrease, text: 'Tùy chỉnh chế độ phát nhạc'),
                const Divider(),
                const PremiumFeature(icon: Icons.mediation, text: 'Tính năng nghe nhạc nâng cao'),
                const Divider(),
                const PremiumFeature(icon: Icons.auto_awesome, text: 'Hiệu ứng bài hát'),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: context.width*0.34,
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Styles.greyLight,
        child: Column(
          children: [
            Center(
              child: Text(
                'Tự động gia hạn hàng tháng, hủy bất cứ lúc nào',
                style: context.theme.textTheme.titleMedium,
              ),
            ),
            CusButton(text: "Nâng cấp", color: Colors.orange,)

          ],
        ),
      ),
    );
  }
}

class PremiumPackageCard extends StatelessWidget {
  final String title;
  final String month;
  final String price;
  final bool isSelected;

  const PremiumPackageCard({super.key,
    required this.title,
    required this.price,
    required this.isSelected, required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width*0.35,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? Colors.orange : Colors.grey, width: 2),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headlineSmall?.copyWith(),
          ),
          Text(
            month,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Styles.grey
            ),
            // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class PremiumFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const PremiumFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }
}
class Package {
  final String title;
  final String month;
  final String price;
  bool isSelected;

  Package({
    required this.title,
    required this.month,
    required this.price,
    this.isSelected = false,
  });
}
