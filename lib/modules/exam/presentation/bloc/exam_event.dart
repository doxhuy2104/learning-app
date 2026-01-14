import 'package:equatable/equatable.dart';

sealed class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object> get props => [];
}

class GetExams extends ExamEvent {}

class GetExamQuestions extends ExamEvent {
  final int examId;

  const GetExamQuestions({required this.examId});
}

class AddUserAnswer extends ExamEvent {
  final int examId;
  final int questionOrderIndex;
  final int? answerOrderIndex;
  final bool? isCorrect;
  final String? shortAnswer;
  final String? trueFalseAnswer;
  const AddUserAnswer({
    required this.examId,
    this.answerOrderIndex,
    required this.questionOrderIndex,
    this.isCorrect,
    this.shortAnswer,
    this.trueFalseAnswer,
  });
}

class ChangeUserAnswer extends ExamEvent {
  final int examId;
  final int questionOrderIndex;
  final int? answerOrderIndex;
  final bool isCorrect;
  final String? shortAnswer;
  const ChangeUserAnswer({
    required this.examId,
    this.answerOrderIndex,
    required this.questionOrderIndex,
    required this.isCorrect,
    this.shortAnswer,
  });
}

class SubmitExam extends ExamEvent {
  final int examId;
  final int timeSpent;
  final int? quesCount;
  final int subjectId;
  const SubmitExam({
    required this.examId,
    required this.timeSpent,
    this.quesCount,
    required this.subjectId,
  });
}

class ResetExamData extends ExamEvent {}

class GetHistories extends ExamEvent {
  // final int page;
  // final int limit;
  // const GetHistory({required this.page, this.limit});
}

class GetHistory extends ExamEvent {
  final int historyId;
  final int examId;
  const GetHistory({required this.historyId, required this.examId});
}
