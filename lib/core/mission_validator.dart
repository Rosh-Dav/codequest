class MissionValidator {
  
  static const String _success = "SUCCESS";
  static const String _syntaxError = "SYNTAX_ERROR";
  static const String _formatError = "FORMAT_ERROR";

  static const String _missingCheck = "MISSING_CHECK"; // Missing type() calls
  static const String _typeError = "TYPE_ERROR";       // Missing required types

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

  /// Validates input for Mission 2: Assign fuel = 60
  /// Rules:
  /// 1. Contains 'fuel'
  /// 2. Uses single '=' (not '==')
  /// 3. Contains '60'
  /// 4. No quotes around 60
  /// 5. No extra symbols
  static String validateMission2(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();
    
    // Check for variable name
    if (!trimmed.contains('fuel')) return _formatError;
    
    // Check for assignment
    if (!trimmed.contains('=')) return _syntaxError;
    if (trimmed.contains('==')) return _syntaxError; // Equality check not allowed
    
    // Check for value
    if (!trimmed.contains('60')) return _formatError;
    
    // Check for invalid quotes
    if (trimmed.contains('"60"') || trimmed.contains("'60'")) return _syntaxError;
    
    // Check strict pattern (allowing spaces)
    // Regex: ^fuel\s*=\s*60$
    final RegExp regex = RegExp(r'^fuel\s*=\s*60$');
    if (!regex.hasMatch(trimmed)) {
       // If it failed regex but passed basic checks, it might be case sensitive or have extra junk
       if (trimmed.toLowerCase().startsWith('fuel')) {
         if (input.contains('Fuel')) return _syntaxError; // Case sensitivity
       }
       return _syntaxError;
    }

    return _success;
  }

  /// Validates input for Mission 3: Signal Formats
  /// Requirements:
  /// 1. Assign 1 int, 1 float, 1 string, 1 bool
  /// 2. Call type() at least 4 times
  static String validateMission3(String input) {
    if (input.isEmpty) return _formatError;
    
    final lines = input.split('\n');
    bool hasInt = false;
    bool hasFloat = false;
    bool hasStr = false;
    bool hasBool = false;
    int typeCalls = 0;

    // Regex patterns
    // Assignment: var = value
    final assignmentRegex = RegExp(r'^\s*([a-zA-Z_]\w*)\s*=\s*(.+)$');
    final typeCallRegex = RegExp(r'type\s*\(');

    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      
      // Check for type() calls
      if (typeCallRegex.hasMatch(line)) {
        typeCalls++;
      }

      // Check for assignments
      final match = assignmentRegex.firstMatch(line.trim());
      if (match != null) {
        String value = match.group(2)!.trim();
        
        // Remove trailing comments
        if (value.contains('#')) value = value.split('#')[0].trim();
        
        // Analyze type
        if (RegExp(r'^\d+$').hasMatch(value)) {
          hasInt = true;
        } else if (RegExp(r'^\d+\.\d+$').hasMatch(value)) {
          hasFloat = true;
        } else if (RegExp(r'^["].*["]$').hasMatch(value) || RegExp(r"^['].*[']$").hasMatch(value)) {
          hasStr = true;
        } else if (value == 'True' || value == 'False') {
          hasBool = true;
        }
      }
    }

    // Validation
    if (!hasInt && !hasFloat && !hasStr && !hasBool) return _formatError;
    
    // Check missing types (Relaxed? No, requirement says "One of each")
    if (!hasInt || !hasFloat || !hasStr || !hasBool) {
      return _typeError;
    }

    if (typeCalls < 4) return _missingCheck;

    return _success;
  }

  /// Validates input for Mission 4: Command Receiver
  /// Requirements: name = input()
  static String validateMission4(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();
    
    // Check for assignment to 'name'
    if (!trimmed.startsWith("name")) return _formatError;
    if (!trimmed.contains("=")) return _syntaxError;
    
    // Check for input() call
    if (!trimmed.contains("input")) return _formatError;
    if (!trimmed.contains("input()")) return _syntaxError; // Parentheses required
    
    // Strict check: name = input()
    // Allowing spaces
    final regex = RegExp(r'^name\s*=\s*input\(\)$');
    if (!regex.hasMatch(trimmed)) return _syntaxError;

    return _success;
  }

  /// Validates input for Mission 5: Data Converter
  /// Requirements: speed = int(input())
  static String validateMission5(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();

    // Check variable name
    if (!trimmed.startsWith("speed")) return _formatError;
    
    // Check int conversion
    if (!trimmed.contains("int")) return _formatError;
    if (!trimmed.contains("int(")) return _syntaxError;
    
    // Check input nesting
    // Expected: speed = int(input())
    final regex = RegExp(r'^speed\s*=\s*int\(\s*input\(\)\s*\)$');
    if (!regex.hasMatch(trimmed)) {
       // Check for specific error patterns
       if (trimmed.contains("input") && !trimmed.contains("input()")) return _syntaxError;
       return _syntaxError;
    }

    return _success;
  }

  /// Validates input for Mission 6: Math Core
  /// Requirements: eff = fuel / time
  static String validateMission6(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();
    
    // Check variable name
    if (!trimmed.startsWith("eff")) return _formatError;
    
    // Check assignment
    if (!trimmed.contains("=")) return _syntaxError;
    
    // Check division
    if (!trimmed.contains("/")) return _formatError;
    
    // Check components
    if (!trimmed.contains("fuel")) return _formatError;
    if (!trimmed.contains("time")) return _formatError;
    
    // Strict check: eff = fuel / time
    final regex = RegExp(r'^eff\s*=\s*fuel\s*/\s*time$');
    if (!regex.hasMatch(trimmed)) {
       if (trimmed.contains("*")) return _syntaxError; // Wrong operator
       return _syntaxError;
    }

    return _success;
  }

  /// Validates input for Mission 7: Engineer Notes
  static String validateMission7(String input) {
    if (input.isEmpty) return _formatError;
    final lines = input.split('\n');
    
    bool hasComment = false;
    bool hasCode = false;
    bool commentBeforeCode = false;
    
    for (var line in lines) {
      final tLine = line.trim();
      if (tLine.isEmpty) continue;
      
      if (tLine.startsWith("#")) {
        hasComment = true;
      } else if (tLine.contains("speed") && tLine.contains("=") && tLine.contains("80")) {
        hasCode = true;
        if (hasComment) commentBeforeCode = true;
      }
    }
    
    if (!hasComment) return _syntaxError;
    if (!hasCode) return _formatError;
    if (!commentBeforeCode) return _formatError;

    return _success;
  }

  /// Validates input for Mission 8: Alignment System (Indentation)
  /// Task: Fix indentation for print inside if speed > 50:
  static String validateMission8(String input) {
    if (input.isEmpty) return _formatError;
    final lines = input.split('\n');
    
    if (lines.length < 2) return _syntaxError;
    
    // Line 1: if speed > 50:
    final line1 = lines[0].trim();
    if (!line1.startsWith("if") || !line1.endsWith(":") || !line1.contains("speed > 50")) {
      return _syntaxError;
    }
    
    // Line 2: Must be indented print("Fast")
    final line2Raw = lines[1];
    if (line2Raw.trim() != 'print("Fast")') return _formatError;
    
    // Check indentation (at least 2 spaces)
    if (!line2Raw.startsWith("  ") && !line2Raw.startsWith("\t")) {
      return _syntaxError; // Not indented
    }

    return _success;
  }

  /// Validates input for Mission 9: Decision Unit (if/elif/else)
  static String validateMission9(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();
    
    if (!trimmed.contains("if") || !trimmed.contains("elif") || !trimmed.contains("else")) {
      return _formatError;
    }
    
    // Basic structure check
    if (!trimmed.contains(":")) return _syntaxError;
    
    final lines = input.split('\n');
    bool hasIf = false, hasElif = false, hasElse = false;
    
    for (var line in lines) {
      final t = line.trim();
      if (t.startsWith("if ")) hasIf = true;
      if (t.startsWith("elif ")) hasElif = true;
      if (t.startsWith("else:")) hasElse = true;
    }
    
    if (hasIf && hasElif && hasElse) return _success;
    return _syntaxError;
  }

  /// Validates input for Mission 10: Auto-Repeater (for Loop)
  static String validateMission10(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();
    
    if (!trimmed.contains("for") || !trimmed.contains("in range(")) return _formatError;
    if (!trimmed.contains("range(3)")) return _formatError;
    if (!trimmed.contains(":")) return _syntaxError;
    
    // Indentation check
    final lines = input.split('\n');
    bool foundPrint = false;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains("print")) {
        if (lines[i].startsWith("  ") || lines[i].startsWith("\t")) {
          foundPrint = true;
        }
      }
    }
    
    return foundPrint ? _success : _syntaxError;
  }

  /// Validates input for Mission 11: Continuous Monitor (while Loop)
  static String validateMission11(String input) {
    if (input.isEmpty) return _formatError;
    final trimmed = input.trim();
    
    if (!trimmed.contains("while")) return _formatError;
    if (!trimmed.contains("fuel > 0")) return _formatError;
    if (!trimmed.contains("fuel -=") && !trimmed.contains("fuel = fuel - 1")) return _formatError;
    
    return _success;
  }
}
