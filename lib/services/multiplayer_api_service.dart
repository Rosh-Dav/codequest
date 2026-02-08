import 'dart:convert';
import 'package:http/http.dart' as http;

class MultiplayerApiService {
  // Use localhost for development
  // Change to your deployed URL for production
  final String baseUrl = 'http://localhost:8000';
  
  String? _token;
  
  // Store token for authenticated requests
  void setToken(String token) {
    _token = token;
  }
  
  String? get token => _token;
  
  // Helper method for authenticated requests
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }
  
  // Authentication
  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: _getHeaders(),
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['token'];
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: _getHeaders(includeAuth: true),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user info');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Room Management
  Future<Map<String, dynamic>> createRoom(
    String mode,
    int maxPlayers,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/rooms/create'),
        headers: _getHeaders(includeAuth: true),
        body: json.encode({
          'mode': mode,
          'max_players': maxPlayers,
        }),
      );
      
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to create room');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> joinRoom(String roomCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/rooms/$roomCode/join'),
        headers: _getHeaders(includeAuth: true),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to join room');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> leaveRoom(String roomCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/rooms/$roomCode/leave'),
        headers: _getHeaders(includeAuth: true),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to leave room');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> startGame(String roomCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/rooms/$roomCode/start'),
        headers: _getHeaders(includeAuth: true),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to start game');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> getRoom(String roomCode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/rooms/$roomCode'),
        headers: _getHeaders(includeAuth: true),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to get room');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
