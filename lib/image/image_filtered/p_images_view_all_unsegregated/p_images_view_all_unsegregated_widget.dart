import 'package:flutter/material.dart';
import '/index.dart';
export 'p_images_view_all_unsegregated_model.dart';

/// Screen displaying waste records filtered by Unsegregated status.
/// Delegated to [PImagesViewAllWidget] with initial filter 'Unsegregated'.
class PImagesViewAllUnsegregatedWidget extends StatelessWidget {
  const PImagesViewAllUnsegregatedWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Unsegregated';
  static String routePath = '/pImagesViewAllUnsegregated';

  @override
  Widget build(BuildContext context) {
    return const PImagesViewAllWidget(
      initialStatus: 'Unsegregated',
    );
  }
}
