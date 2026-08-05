import 'package:flutter/material.dart';

class ItemIcons {

  static String getEmoji(String item) {

    final name = item.toLowerCase();

    if (name.contains("banana")) return "🍌";

    if (name.contains("grape")) return "🍇";

    if (name.contains("broccoli")) return "🥦";

    if (name.contains("potato")) return "🥔";

    if (name.contains("lettuce")) return "🥬";

    if (name.contains("peas")) return "🫛";

    if (name.contains("zucchini") || name.contains("zuchinni"))
      return "🥒";

    return "🛒";
  }

}