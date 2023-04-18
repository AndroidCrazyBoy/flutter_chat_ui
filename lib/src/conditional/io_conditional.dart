import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'base_conditional.dart';

/// Create a [IOConditional].
///
/// Used from conditional imports, matches the definition in `conditional_stub.dart`.
BaseConditional createConditional() => IOConditional();

/// A conditional for anything but browser.
class IOConditional extends BaseConditional {
  /// Returns [NetworkImage] if URI starts with http
  /// otherwise uses IO to create File
  @override
  ImageProvider getProvider(String uri, {Map<String, String>? headers}) {
    if (uri.startsWith('http')) {
      return NetworkImage(uri, headers: headers);
    } else if(uri.startsWith('assets')) {
      return AssetImage(uri);
    } else if(isFilePath(uri)) {
      return FileImage(File(uri));
    } else {
      return MemoryImage(base64Decode(uri));
    }
  }

  bool isFilePath(String path) {
    final file = File(path);
    return file.existsSync();
  }
}
