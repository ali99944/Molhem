String upperFirstLetter(String original){
  if(original.isEmpty) return '';
  return original[0].toUpperCase() + original.substring(1);
}