import 'package:drip_store/common_widgets/profile_bar_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: ProfileBarWidget(
            image: 'https://pict.sindonews.net/webp/480/pena/news/2022/01/27/700/669527/7-kelemahan-terbesar-naruto-uzumaki-di-serial-naruto-kno.webp',
            name: 'Louis Ginting',
            email: 'louisginting@gmail.com',
          )
        ),
      ),
    );
  }
}