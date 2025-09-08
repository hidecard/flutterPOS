import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/assets/app_assets.dart';
import '../../../../app/themes/app_sizes.dart';
import '../../../../service_locator.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authProvider = sl<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            welcomeMessage(),
            signInButton(),
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
            const Image(image: AssetImage(AppAssets.welcome), width: 150, height: 150),
            const SizedBox(height: AppSizes.padding),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome to Flutter POS app',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget signInButton() {
    return AppButton(
      text: 'Continue',
      onTap: () async {
        AppDialog.showDialogProgress();

        try {
          final res = await _authProvider.signIn();

          if (res.isSuccess) {
            // Post-frame safe navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                GoRouter.of(context).go('/home');
              }
            });
          } else {
            AppDialog.showErrorDialog(error: res.error?.message ?? 'Sign-in failed');
          }
        } catch (e) {
          AppDialog.showErrorDialog(error: e.toString());
        } finally {
          AppDialog.closeDialog();
        }
      },
    );
  }
}
