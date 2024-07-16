
//todo: handle fail safe and different use cases
extension FetchInitials on String {
  String getInitialCharacters() {
    final initials = split(' ');
    final firstInit = initials.first.toUpperCase().substring(0, 1);
    final secondInit = initials.elementAt(1).toUpperCase().substring(0, 1);

    return '$firstInit$secondInit';
  }
}