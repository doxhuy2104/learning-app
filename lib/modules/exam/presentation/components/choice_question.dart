import 'package:flutter/material.dart';
import 'package:learning_app/core/models/question_model.dart';

class ChoiceQuestion extends StatefulWidget {
  const ChoiceQuestion({super.key, required this.question});
  final QuestionModel question;
  @override
  State<StatefulWidget> createState() => _ChoiceQuestionState();
}

class _ChoiceQuestionState extends State<ChoiceQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
