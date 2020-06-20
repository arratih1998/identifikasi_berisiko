class Validator {
  static String noEmptyValidator(String value) {
    if (value == null || value.isEmpty)
      return "Field ini tidak boleh kosong";
    else
      return null;
  }

  static String emailValidator(String value) {
    final exp = RegExp("([\\w\\.\\-_]+)?\\w+@[\\w-_]+(\\.\\w+){1,}");
    if (exp.hasMatch(value))
      return null;
    else
      return "Email yang kamu masukan tidak valid";
  }
}
