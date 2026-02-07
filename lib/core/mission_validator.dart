class MissionValidator {
  
  static const String _success = "SUCCESS";
  static const String _syntaxError = "SYNTAX_ERROR";
  static const String _formatError = "FORMAT_ERROR";

  /// Validates input for Mission 1: Print "System Online"
  /// Rules:
  /// 1. Must start with 'print('
  /// 2. Must contain double quotes
  /// 3. Must contain 'System Online'
  /// 4. Must end with ')'
  static String validateMission1(String input) {
    if (input.isEmpty) return _formatError;
    
    final trimmed = input.trim();
    
    // Check basic structure
    if (!trimmed.startsWith("print(")) return _syntaxError;
    if (!trimmed.endsWith(")")) return _syntaxError;
    
    // Check quotes
    if (!trimmed.contains('"')) return _syntaxError;
    
    // Check exact content (case sensitive per requirements)
    // Allows for spaces inside the parenthesis but outside quotes? 
    // Prompt says: "Extra spaces allowed", "Reject: print(System Online), print('System Online')"
    
    // Extract content between parentheses
    final contentStartIndex = trimmed.indexOf('(') + 1;
    final contentEndIndex = trimmed.lastIndexOf(')');
    if (contentStartIndex >= contentEndIndex) return _syntaxError;
    
    final content = trimmed.substring(contentStartIndex, contentEndIndex).trim();
    
    // Check if content is properly quoted
    if (!content.startsWith('"') || !content.endsWith('"')) {
       return _syntaxError; // Quotes required
    }
    
    // Check inside quotes
    final innerText = content.substring(1, content.length - 1);
    if (innerText != "System Online") {
      return _formatError; // Content mismatch
    }

    return _success;
  }
}
