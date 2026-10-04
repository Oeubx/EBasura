import 'package:flutter/material.dart';
import '/index.dart';
export 'p_images_view_all_verified_model.dart';

/// Screen displaying waste records filtered by Verified status.
/// Delegated to [PImagesViewAllWidget] with initial filter 'Verified'.
class PImagesViewAllVerifiedWidget extends StatelessWidget {
  const PImagesViewAllVerifiedWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Verified';
  static String routePath = '/pImagesViewAllVerified';

  @override
  Widget build(BuildContext context) {
    return const PImagesViewAllWidget(
      initialStatus: 'Verified',
    );
  }
}
