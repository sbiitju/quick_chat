import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_chat/core/constants/app_assets.dart';
import 'package:quick_chat/core/constants/app_strings.dart';
import 'package:quick_chat/core/constants/app_values.dart';
import 'package:quick_chat/core/routes/routes.dart';
import 'package:quick_chat/features/auth/providers/auth_providers.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    ref.listen(authProvider, (_, state) {
      if (state?.emailVerified == true) {
        context.goNamed(Routes.home);
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Let's get started!"),
            const SizedBox(height: 10),
            isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      isLoading.value = true;
                      await ref.read(authProvider.notifier).signInWithGoogle();
                      isLoading.value = false;
                    },
                    child: _buildSignInButtonContent(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(AppStrings.loginButtonText),
        SizedBox(width: AppValues.dimen_10.sp),
        SvgPicture.asset(AppAssets.icGoogle,
            width: AppValues.iconSize_28.sp, height: AppValues.iconSize_28.sp)
      ],
    );
  }
}
