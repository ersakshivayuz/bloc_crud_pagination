import 'package:bloc_crud_pagination/screens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'cubit/post_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);
  await Hive.openBox('postsBox');

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (_) => PostCubit()..loadFromLocal(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bloc CRUD with Pagination',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: PostScreen(),
      ),
    );
  }
}
