class Question{
  final String question;
  final String questionAr;
  final String description;
  final String descriptionAr;
  final List<dynamic> choices;
  final List<dynamic> choicesAr;
  final int answer;
  final String hint;
  final String hintAr;
  final String? image;

  Question({
    required this.question,
    required this.description,
    required this.choices,
    required this.answer,
    required this.hint,
    required this.image,
    required this.questionAr,
    required this.descriptionAr,
    required this.choicesAr,
    required this.hintAr
  });

  factory Question.fromFirestore(Map data){
    return Question(
      question: data['question'],
      description: data['description'],
      choices: data['choices'],
      answer: data['answer'],
      hint: data['hint'],
      image: data['image'],
      questionAr: data['question-ar'],
      choicesAr: data['choices-ar'],
      hintAr: data['hint-ar'],
      descriptionAr: data['description-ar']
    );
  }
}