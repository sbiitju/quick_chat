String makeConversationID(String currentUserEmail, String otherUserEmail) {
  final emails = [currentUserEmail, otherUserEmail];
  emails.sort();
  return emails.join('_');
}
