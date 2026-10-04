import 'package:flutter/material.dart';
import '/index.dart';
export 'p_images_view_all_segregated_model.dart';

/// Screen displaying waste records filtered by Segregated status.
/// Delegated to [PImagesViewAllWidget] with initial filter 'Segregated'.
class PImagesViewAllSegregatedWidget extends StatelessWidget {
  const PImagesViewAllSegregatedWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Segregated';
  static String routePath = '/pImagesViewAllSegregated';

  @override
  Widget build(BuildContext context) {
    return const PImagesViewAllWidget(
      initialStatus: 'Segregated',
    );
  }
}
