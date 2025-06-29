import 'package:drip_store/common_widgets/guest_action_widget.dart';
import 'package:drip_store/common_widgets/profile_bar_widget.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/profile_user_provider.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      // ignore: use_build_context_synchronously
      context.read<ProfileUserProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedin = context.watch<AuthProvider>().isLoggedIn;
    final getProfile = context.watch<ProfileUserProvider>().profileUser;
    final isLoading = context.watch<AuthProvider>().isLoading;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Stack(
          children: [
            SingleChildScrollView(
              child:
                  isLoggedin
                      ? ProfileBarWidget(
                        image:
                            getProfile?.user?.profilePicture ??
                            'https://wallpapers.com/images/hd/naruto-pictures-ifftdoc33971s72e.jpg',
                        name: getProfile?.user?.name ?? 'Guest',
                        email: getProfile?.user?.email ?? '',
                      )
                      : Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppMargin.m12,
                          vertical: AppPadding.p12,
                        ),
                        child: GuestActionWidget(
                          width: 100,
                          height: 100,
                          iconSize: AppSize.s40,
                          fontSize: FontSizeManager.f18,
                        ),
                      ),
            ),

            if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
