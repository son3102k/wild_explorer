import 'package:flutter/widgets.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';

import 'generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
