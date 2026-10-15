import 'package:flutter/material.dart';
import '/index.dart';
export 'p_images_view_all_flagged_model.dart';

/// Screen displaying waste records filtered by Flagged status.
/// Delegated to [PImagesViewAllWidget] with initial filter 'Flagged'.
class PImagesViewAllFlaggedWidget extends StatelessWidget {
  const PImagesViewAllFlaggedWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Flagged';
  static String routePath = '/pImagesViewAllFlagged';

  @override
  Widget build(BuildContext context) {
    return const PImagesViewAllWidget(
      initialStatus: 'Flagged',
    );
  }
}
