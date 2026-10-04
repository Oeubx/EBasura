with open('lib/image/image_uploads/p_img_upload_a_guest/p_img_upload_a_guest_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read().replace('\r\n', '\n')

import_target = "import '/image/c_image_informational_dialog/c_image_informational_dialog_widget.dart';"
import_repl = import_target + "\nimport '/image/c_camera_framing_overlay/c_camera_framing_overlay_widget.dart';"
content = content.replace(import_target, import_repl, 1)

target = """                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Opacity("""

replacement = """                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const Positioned.fill(
                                            child: CCameraFramingOverlayWidget(
                                              height: 220.0,
                                            ),
                                          ),
                                          Opacity("""

if target in content:
    content = content.replace(target, replacement, 1)
    with open('lib/image/image_uploads/p_img_upload_a_guest/p_img_upload_a_guest_widget.dart', 'w', encoding='utf-8') as f:
        f.write(content)
    print('SUCCESS GUEST')
else:
    print('TARGET NOT FOUND IN GUEST')
