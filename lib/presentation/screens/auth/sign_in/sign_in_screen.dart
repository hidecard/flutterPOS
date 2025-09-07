import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';
import '../../../../app/assets/app_assets.dart';
import '../../../../app/themes/app_sizes.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../widgets/app_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            welcomeMessage(),
            continueButton(context),
          ],
        ),
      ),
    );
  }

  Widget welcomeMessage() {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 270),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImage(
              image: AppAssets.welcome,
              imgProvider: ImgProvider.assetImage,
            ),
            const SizedBox(height: AppSizes.padding),
            Text(
              'Welcome!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome to Flutter POS app',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget continueButton(BuildContext context) {
    return AppButton(
      text: 'Continue',
      onTap: () {
        // GoRouter navigation
        AppRoutes.router.go('/main');
      },
    );
  }
}
