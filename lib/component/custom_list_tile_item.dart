import 'package:flutter/material.dart';

Widget customListTile({
  required Icon icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: icon,
    title: Text(title),
    onTap: onTap,
  );
}

