import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_sqflite_app/bloc_observer.dart';
import 'package:test_sqflite_app/cubit/note_cubit.dart';
import 'package:test_sqflite_app/cubit/note_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => NoteCubit()..createDatabase(),
        child: BlocConsumer<NoteCubit, NoteState>(
          listener: (context, state) {
            var cubit = NoteCubit.get(context);

            if(state is InsertIntoDatabaseSuccessfullyState){
              cubit.getFromDatabase(cubit.db);
            }
          },
          builder: (context, state) {
            var cubit = NoteCubit.get(context);

            return ConditionalBuilder(
                condition: state is! TableCreatedLoadingState,
                builder: (context) => Column(
                      children: [
                        TextFormField(
                          controller: cubit.titleController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: cubit.descriptionController,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              cubit.insertIntoDatabase(
                                  title: cubit.titleController.text,
                                  description:
                                      cubit.descriptionController.text);
                            },
                            child: Text("Send")),
                        if (cubit.noteModel.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>Column(
                              children: [
                                Text(cubit.noteModel[index].title),
                                Text(cubit.noteModel[index].description),
                              ],
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 8,
                            ),
                            itemCount: cubit.noteModel.length,
                          )
                      ],
                    ),
                fallback: (context) => CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
