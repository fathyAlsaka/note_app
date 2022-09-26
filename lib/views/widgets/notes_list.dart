import 'package:flutter/material.dart';
import 'package:notes_app/config/app_colors.dart';
import 'package:notes_app/config/global.dart';
import 'package:notes_app/models/database/database.dart';
import 'package:notes_app/views/widgets/note_overview.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 30,
        ),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: FutureBuilder(
          future: NotesDatabase.notes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (Global.deleteButtonVisible.length != snapshot.data!.length) {
                Global.deleteButtonVisible =
                    List.generate(snapshot.data!.length, (index) => false);
              }
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.border,
                  height: 3,
                  thickness: 1,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return NoteOverview(
                    note: snapshot.data![snapshot.data!.length - index - 1],
                    index: snapshot.data!.length - index - 1,
                    notifyParent: () {
                      setState(() {});
                    },
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
