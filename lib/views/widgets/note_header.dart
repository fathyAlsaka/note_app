import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../screens/home_screen.dart';

class NoteHeader extends StatelessWidget {
  const NoteHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backToNotesButton(context),
          doneButton(context),
        ],
      ),
    );
  }

  Widget backToNotesButton(context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          )),
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
    );
  }

  Widget doneButton(context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          )),
      child: Text(
        "Done",
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
