import 'package:flutter/material.dart';
import 'package:notes_app/models/database/database.dart';
import '../../config/app_colors.dart';
import '../screens/note_creation_screen.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: AppColors.footer,
        border: Border(
          top: BorderSide(color: AppColors.border!, width: 0.5),
        ),
      ),
      child: Stack(
        children: [
          notesCountWidget(),
          createNoteButton(context),
        ],
      ),
    );
  }
  
  Widget notesCountWidget(){
    return Center(
      child: FutureBuilder(
        future: NotesDatabase.notes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
                "${snapshot.data!.length} ${snapshot.data!.length > 1 ? "Notes" : "Note"}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  
  Widget createNoteButton(context){
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteCreationScreen(),
            )),
        icon: Icon(
          Icons.note_alt_outlined,
          color: AppColors.primary,
        ),
      ),
    );
  }
  
}
