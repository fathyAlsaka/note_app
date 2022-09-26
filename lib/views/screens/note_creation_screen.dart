import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_app/config/app_colors.dart';
import '../../models/database/database.dart';
import '../../models/database/note.dart';
import 'home_screen.dart';

class NoteCreationScreen extends StatefulWidget {
  NoteCreationScreen({Key? key}) : super(key: key);
  NoteCreationScreen.edit(this.note, {super.key}) {
    edit = true;
  }

  late Note note;
  bool edit = false;

  @override
  State<NoteCreationScreen> createState() => _NoteCreationScreenState();
}

class _NoteCreationScreenState extends State<NoteCreationScreen> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (widget.edit) {
      titleTextController.text = widget.note.title;
      contentTextController.text = widget.note.content;
    }

    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: Column(
          children: [
            createNoteHeader(),
            const SizedBox(
              height: 10,
            ),
            titleTextField(),
            contentTextField(),
          ],
        ),
      ),
    );
  }

  Widget createNoteHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              saveNote(titleTextController.text, contentTextController.text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primary,
                ),
                Text(
                  "Notes",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              colorPickerWidget();
            },
            child: Text(
              "change color",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              saveNote(titleTextController.text, contentTextController.text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          try {
            if (titleTextController.text.length >= 25 &&
                event.logicalKey == LogicalKeyboardKey.alphanumeric && titleFocusNode.hasFocus) {
              contentTextController.text =
                  (event.character! + contentTextController.text ?? "")!.trim();
              contentTextController.selection =
                  TextSelection.fromPosition(const TextPosition(offset: 1));
            }
            if (titleTextController.selection.baseOffset >= 24 &&
                event.logicalKey == LogicalKeyboardKey.arrowRight && titleFocusNode.hasFocus) {
              FocusScope.of(context).requestFocus(contentFocusNode);
              contentTextController.selection =
                  TextSelection.fromPosition(const TextPosition(offset: 0));
            }
          } catch (e) {}
        },
        child: TextField(
          onSubmitted: (value) =>
              FocusScope.of(context).requestFocus(contentFocusNode),
          onChanged: (value) {
            if (titleTextController.text.length >= 25) {
              FocusScope.of(context).requestFocus(contentFocusNode);
            }
          },
          maxLength: 25,
          controller: titleTextController,
          focusNode: titleFocusNode,
          cursorHeight: 40,
          maxLines: 1,
          enabled: true,
          autofocus: true,
          cursorColor: AppColors.primary,
          cursorWidth: 2,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            counterText: "",
          ),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.currentColor,
          ),
        ),
      ),
    );
  }

  Widget contentTextField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            try {
              if (event.logicalKey == LogicalKeyboardKey.backspace &&
                  contentTextController.selection.baseOffset == 0 &&
                  contentFocusNode.hasFocus) {
                FocusScope.of(context).requestFocus(titleFocusNode);
              }
              if (contentTextController.selection.baseOffset == 0 &&
                  event.logicalKey == LogicalKeyboardKey.arrowLeft && contentFocusNode.hasFocus) {
                FocusScope.of(context).requestFocus(titleFocusNode);
                titleTextController.selection =
                    TextSelection.fromPosition(const TextPosition(offset: 25));
              }
            } catch (e) {}
          },
          child: TextField(
            controller: contentTextController,
            focusNode: contentFocusNode,
            keyboardType: TextInputType.multiline,
            cursorHeight: 40,
            maxLines: null,
            enabled: true,
            autofocus: true,
            cursorColor: AppColors.primary,
            cursorWidth: 2,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            style: TextStyle(
              fontSize: 20,
              color: AppColors.currentColor,
            ),
          ),
        ),
      ),
    );
  }

  saveNote(String title, String content) {
    if (title.trim().isNotEmpty || content.trim().isNotEmpty) {
      Note note = Note.create(
          title: title.trim().isNotEmpty ? title : "Untitled",
          content: content,
          creationDate: DateTime.now().toString(),
          modifyDate: DateTime.now().toString());
      if (widget.edit) {
        note.id = widget.note.id;
        NotesDatabase.updateNote(note);
      } else {
        NotesDatabase.createNote(note);
      }
    }
  }

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => AppColors.pickerColor = color);
  }

  Future colorPickerWidget() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: AppColors.pickerColor,
            onColorChanged: changeColor,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => AppColors.currentColor = AppColors.pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
