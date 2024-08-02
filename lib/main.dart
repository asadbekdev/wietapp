import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wietapp/application/cats/cats_bloc.dart';
import 'package:wietapp/application/tier/tier_bloc.dart';
import 'package:wietapp/data/repositories/cats_repository.dart';
import 'package:wietapp/presentation/pages/home_page.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  if (kIsWeb) {
    runApp(
      DevicePreview(
        enabled: true, // Turn off when pushing production
        builder: (context) => MyApp(),
      ),
    );
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CatsBloc(CatsRepository())),
        BlocProvider(create: (context) => TierBloc(CatsRepository())),
      ],
      child: MaterialApp(
        title: 'Cats App',
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: CatsPage(),
      ),
    );
  }
}
