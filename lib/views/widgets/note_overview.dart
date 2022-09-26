import 'package:flutter/material.dart';
import 'package:notes_app/config/app_colors.dart';
import 'package:notes_app/models/database/database.dart';
import 'package:notes_app/views/screens/home_screen.dart';
import 'package:notes_app/views/screens/note_creation_screen.dart';
import '../../config/global.dart';
import '../../models/database/note.dart';

class NoteOverview extends StatefulWidget {
   const NoteOverview({
    Key? key,
    required this.note, required this.index, required this.notifyParent,
  }) : super(key: key);

  final Note note;
  final int index;
   final Function() notifyParent;

  @override
  State<NoteOverview> createState() => _NoteOverviewState();
}

class _NoteOverviewState extends State<NoteOverview> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToEditView,
      onLongPress: activateDeleteState,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: AppColors.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              titleTextWidget(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  modifyDateTextWidget(),
                  const SizedBox(
                    width: 10,
                  ),
                  contentTextWidget(),
                ],
              ),
            ]),
            Global.deleteButtonVisible[widget.index] ? deleteButton() : Container(),
          ],
        ),
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      onPressed: () {
        NotesDatabase.deleteNote(widget.note.id);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      },
      icon: Icon(Icons.delete, color: AppColors.deleteButton),
    );
  }

  void goToEditView() {
    bool checked = false;
    Global.deleteButtonVisible.forEach((element) {
      if(element){
        checked = true;
      }
    });
    if(checked){
      Global.deleteButtonVisible = List.generate(Global.deleteButtonVisible.length, (index) => false);
      setState(() {});
      widget.notifyParent();
    }else {
      Global.deleteButtonVisible = List.generate(Global.deleteButtonVisible.length, (index) => false);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteCreationScreen.edit(widget.note),
          ));
    }
  }

  void activateDeleteState() {
    Global.deleteButtonVisible = List.generate(Global.deleteButtonVisible.length, (index) => false);
    Global.deleteButtonVisible[widget.index] = true;
    setState(() {});
    widget.notifyParent();
  }

  Widget titleTextWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        widget.note.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget modifyDateTextWidget() {
    return Text(
      widget.note.modifyDate.split(".")[0],
      style: TextStyle(
        fontSize: 15,
        color: AppColors.subtitleText,
      ),
    );
  }

  Widget contentTextWidget() {
    return SizedBox(
      width: 80,
      child: Text(
        widget.note.content,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.subtitleText,
        ),
      ),
    );
  }
}
