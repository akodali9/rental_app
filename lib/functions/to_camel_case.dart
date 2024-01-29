String toCamelCase(String input) {
  List<String> words = input.split(RegExp(r'\s+|_+|-+'));
  
  if (words.isNotEmpty) {
    String camelCase = words[0].toLowerCase();
    
    for (int i = 1; i < words.length; i++) {
      camelCase += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    
    return camelCase;
  } else {
    return input; // Return original string if it contains no words.
  }
}