// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

const main_colour = Colors.white;
const secondary_colour = Color.fromARGB(255, 38, 206, 85);

const double default_padding = 16.0;

const bool isWeb = kIsWeb;
bool isDesktop = (Platform.isLinux || Platform.isLinux || Platform.isMacOS);
bool isMobile = (Platform.isAndroid || Platform.isIOS);
bool supportState = false;

late LocalAuthentication auth;
bool authenticated = false;
