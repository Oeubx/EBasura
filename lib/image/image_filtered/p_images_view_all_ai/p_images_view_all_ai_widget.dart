import 'package:flutter/material.dart';
import '/index.dart';
export 'p_images_view_all_ai_model.dart';

/// Screen displaying waste records filtered by AI classification status.
/// Delegated to [PImagesViewAllWidget] with initial filter 'Categorized by Ai'.
class PImagesViewAllAiWidget extends StatelessWidget {
  const PImagesViewAllAiWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Ai';
  static String routePath = '/pImagesViewAllAi';

  @override
  Widget build(BuildContext context) {
    return const PImagesViewAllWidget(
      initialStatus: 'Categorized by Ai',
    );
  }
}
