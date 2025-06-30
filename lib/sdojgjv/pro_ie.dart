import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void lauchUrl(BuildContext context, String kmfkgm) async {
  final Uri asdfasdfdgdg = Uri.parse(kmfkgm);
  if (!await launchUrl(asdfasdfdgdg)) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch $asdfasdfdgdg'),
      ),
    );
  }
}
