
class StaticMentorService {
  
  static String getPythonExplanation(String code, String error) {
    String lowerError = error.toLowerCase();
    
    // Custom Validation Errors
    if (lowerError.contains("must contain")) {
      String missing = error.split(":").last.trim();
      return "Cadet, the system requires a specific signal frequency: '$missing'. Your transmission attempt failed because this sequence was omitted from the command buffer.";
    }

    // Standard Python Errors
    if (lowerError.contains("syntaxerror")) {
      return "Logic breach detected! Your syntax does not match our internal protocols. Check for unbalanced brackets or stray characters in the data stream.";
    }
    if (lowerError.contains("indentationerror")) {
      return "Structural misalignment! Python systems require precise indentation for data blocks. Align your code blocks to the propulsion grid.";
    }
    if (lowerError.contains("nameerror")) {
      String name = lowerError.contains("'") ? lowerError.split("'")[1] : "variable";
      return "Unknown identifier! The system does not recognize '$name'. Ensure you have initialized this component before attempting to access its energy.";
    }
    if (lowerError.contains("zerodivisionerror")) {
      return "Mathematical anomaly! Attempting to divide by zero would collapse our warp core. Recalculate your logic immediately.";
    }
    if (lowerError.contains("typeerror")) {
      return "Format mismatch! You are attempting to combine incompatible data types. Ensure your data streams are properly synchronized.";
    }

    return "Unknown data corruption detected. Re-examine your logic structure and ensure it aligns with the Mission Objective.";
  }

  static String getStaticHint(String mentorName, String concept, String task, String error) {
    bool isLuna = mentorName.toUpperCase() == 'LUNA';
    String lowerError = error.toLowerCase();

    // Themed prefix
    String prefix = isLuna 
      ? "Apprentice, the runes are clouded. " 
      : "Cadet, sensors indicate a logic failure. ";

    // Logic for specific errors
    if (lowerError.contains("must contain")) {
      String missing = error.split(":").last.trim();
      return prefix + (isLuna 
        ? "The spell requires the precise inscription of '$missing' to take effect." 
        : "The transmission is missing the required '$missing' component.");
    }

    if (lowerError.contains("semicolon")) {
      return prefix + (isLuna 
        ? "Every ritual must be properly terminated with a semicolon ';' or the energy will leak." 
        : "Termination failure. Add a semicolon ';' to end your command sequence.");
    }

    if (lowerError.contains("printf") || lowerError.contains("format")) {
      return prefix + "The display sequence formatting is incorrect. Check your format specifiers like '%d' or '%s'.";
    }

    // Generic Concept Hints
    switch (concept.toLowerCase()) {
      case 'variables':
        return prefix + "Ensure you have declared the correct type (int, char, etc.) and assigned a value.";
      case 'loops':
        return prefix + "Check your loop condition. If it never becomes false, the energy will spiral out of control!";
      case 'functions':
        return prefix + "A function needs a return type, a name, and parentheses ().";
      default:
        return prefix + "Look closely at your syntax. Even a single misplaced character can break the entire system.";
    }
  }

  static String getStaticChatResponse(String query, String mentorName) {
    bool isLuna = mentorName.toUpperCase() == 'LUNA';
    String q = query.toLowerCase();

    if (q.contains("hello") || q.contains("hi")) {
      return isLuna ? "Greetings, traveler. I am Luna. What knowledge do you seek?" : "Pilot, I am NOVA. Awaiting your transmission.";
    }
    if (q.contains("help")) {
      return "Focus on the Mission Objective. Read the Teaching Panel on the left for instructions on the current concept.";
    }
    if (q.contains("who are you")) {
      return isLuna 
        ? "I am the keeper of Rune City's memories, sworn to guide those who seek the path of logic." 
        : "I am the ByteStar Tactical AI, designed to transform cadets into elite system pilots.";
    }
    
    return isLuna 
      ? "My scrying pools are unclear on that matter. Focus your intent on the current coding challenge." 
      : "Data banks are currently undergoing maintenance for that specific query. Focus on the mission at hand.";
  }
}
