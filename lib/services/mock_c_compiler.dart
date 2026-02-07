import 'dart:async';

class MockCCompiler {
  /// Simulates compiling and running C code.
  /// Returns a tuple of (stdout, stderr).
  static Future<Map<String, String>> compileAndRun(String code) async {
    // Simulate compilation delay for realism
    await Future.delayed(const Duration(milliseconds: 600));

    final StringBuffer stdout = StringBuffer();
    final StringBuffer stderr = StringBuffer();

    // 1. Check for basic syntax errors (very simple checks)
    if (!code.contains('main') && !code.contains('void') && !code.contains('int')) {
      stderr.writeln("error: expected declaration or statement at end of input");
      return {'stdout': '', 'stderr': stderr.toString()};
    }
    
    // 2. Parse printf statements
    // Regex to match: printf("some string");
    // Handles escaped quotes poorly but good enough for MVP
    final printfRegex = RegExp(r'printf\s*\(\s*"([^"]*)"\s*\)\s*;');
    final matches = printfRegex.allMatches(code);

    if (matches.isEmpty && code.contains('printf')) {
      // Exist printf but didn't match regex -> syntax error?
      // Check for missing semicolon
      if (RegExp(r'printf.*[^;]\s*$').hasMatch(code)) {
         stderr.writeln("error: expected ';' before '}' token");
      }
    }

    for (final match in matches) {
      String content = match.group(1) ?? '';
      // Handle \n
      content = content.replaceAll(r'\n', '\n');
      stdout.write(content);
    }

    // 3. Logic for specific mission goals (can be expanded)
    // Mission 1: int power = 100;
    if (code.contains('int power = 100')) {
      // If they didn't print it, maybe we assume success if variable is set?
      // But stdout is what matters for the console.
      // We adding a system log if successful variable set logic is found but no print
      if (stdout.isEmpty) {
         // stdout.writeln("[System] Variable 'power' set to 100.");
      }
    }

    return {'stdout': stdout.toString(), 'stderr': stderr.toString()};
  }
}
