import 'package:flutter/material.dart';
import 'package:notes_app/views/widgets/app_bar.dart';
import 'package:notes_app/views/widgets/footer.dart';
import 'package:notes_app/views/widgets/notes_list.dart';
import '../../config/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: appBarWidget(),
        backgroundColor: AppColors.backGround,
        body: Column(
          children: const [
            NotesList(),
            FooterWidget(),
          ],
        ),
      ),
    );
  }
}
