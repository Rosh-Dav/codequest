import 'dart:convert';
import 'package:http/http.dart' as http;

class Judge0Service {
  // Using the public CE API for demo purposes. 
  // In production, use your own instance or RapidAPI with a key.
  static const String _baseUrl = 'https://ce.judge0.com/submissions'; 
  
  // Language IDs: 50 is C (GCC 9.2.0)
  static const int languageC = 50;

  Future<ExecutionResult> executeCode(String sourceCode, int languageId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?base64_encoded=false&wait=true'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'source_code': sourceCode,
          'language_id': languageId,
          'stdin': '', // Add support for stdin if needed
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ExecutionResult(
          stdout: data['stdout'] ?? '',
          stderr: data['stderr'] ?? '',
          compileOutput: data['compile_output'] ?? '',
          status: data['status']['description'] ?? 'Unknown',
          exitCode: data['exit_code'] ?? -1,
        );
      } else {
        return ExecutionResult(
          stdout: '',
          stderr: 'API Error: ${response.statusCode} - ${response.body}',
          status: 'Error',
        );
      }
    } catch (e) {
      return ExecutionResult(
        stdout: '',
        stderr: 'Network Error: $e',
        status: 'Error',
      );
    }
  }
}

class ExecutionResult {
  final String stdout;
  final String stderr;
  final String compileOutput;
  final String status;
  final int exitCode; // optional

  ExecutionResult({
    this.stdout = '',
    this.stderr = '',
    this.compileOutput = '',
    required this.status,
    this.exitCode = 0,
  });

  bool get isSuccess => status == 'Accepted';
  String get fullOutput => stderr.isNotEmpty ? stderr : (compileOutput.isNotEmpty ? compileOutput : stdout);
}
