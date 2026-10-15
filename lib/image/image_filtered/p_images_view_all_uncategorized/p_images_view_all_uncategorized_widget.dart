import 'package:flutter/material.dart';
import '/index.dart';
export 'p_images_view_all_uncategorized_model.dart';

/// Screen displaying waste records filtered by Uncategorized status.
/// Delegated to [PImagesViewAllWidget] with initial filter 'Uncategorized'.
class PImagesViewAllUncategorizedWidget extends StatelessWidget {
  const PImagesViewAllUncategorizedWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Uncategorized';
  static String routePath = '/pImagesViewAllUncategorized';

  @override
  Widget build(BuildContext context) {
    return const PImagesViewAllWidget(
      initialStatus: 'Uncategorized',
    );
  }
}
