import 'package:flutter/foundation.dart';
import 'dart:async';

/// Mock voice provider that simulates speech-to-text functionality
/// This provides a working implementation without external dependencies
class VoiceProvider with ChangeNotifier {
  bool _isListening = false;
  bool _isAvailable = true; // Always available in mock mode
  String _lastWords = '';
  bool _isSpeaking = false;
  double _confidence = 0.0;
  Timer? _listeningTimer;
  Timer? _speechTimer;

  // Mock responses for demonstration
  final List<String> _mockResponses = [
    'Hello, this is a test message',
    'Create a new task for the development team',
    'Send message to the marketing channel',
    'Schedule a meeting for tomorrow',
    'Update the project status',
    'Add a reminder for the budget review',
    'Call the client about the proposal',
    'Share the design files with the team',
  ];

  // Getters
  bool get isListening => _isListening;
  bool get isAvailable => _isAvailable;
  String get lastWords => _lastWords;
  bool get isSpeaking => _isSpeaking;
  double get confidence => _confidence;

  /// Initialize voice services (mock implementation)
  Future<void> initializeVoice() async {
    // Simulate initialization delay
    await Future.delayed(const Duration(milliseconds: 500));
    _isAvailable = true;
    notifyListeners();
    
    if (kDebugMode) {
      print('Voice services initialized (mock mode)');
    }
  }

  /// Request microphone permission (mock implementation)
  Future<bool> requestPermission() async {
    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always granted in mock mode
  }

  /// Start listening for voice input (mock implementation)
  Future<void> startListening({
    Function(String)? onResult,
    Duration? timeout,
  }) async {
    if (!_isAvailable || _isListening) return;

    _isListening = true;
    _lastWords = '';
    _confidence = 0.0;
    notifyListeners();

    if (kDebugMode) {
      print('Started listening (mock mode)');
    }

    // Simulate listening with realistic delay
    _listeningTimer = Timer(const Duration(seconds: 2), () {
      if (_isListening) {
        // Generate mock speech result
        final randomResponse = (_mockResponses..shuffle()).first;
        _lastWords = randomResponse;
        _confidence = 0.85 + (0.15 * (DateTime.now().millisecond / 1000));
        
        onResult?.call(_lastWords);
        notifyListeners();

        if (kDebugMode) {
          print('Mock speech result: $_lastWords (confidence: ${(_confidence * 100).toInt()}%)');
        }

        // Auto-stop after getting result
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_isListening) {
            stopListening();
          }
        });
      }
    });

    // Auto-timeout
    Timer(timeout ?? const Duration(seconds: 30), () {
      if (_isListening) {
        stopListening();
      }
    });
  }

  /// Stop listening for voice input
  Future<void> stopListening() async {
    if (!_isListening) return;

    _listeningTimer?.cancel();
    _isListening = false;
    notifyListeners();

    if (kDebugMode) {
      print('Stopped listening (mock mode)');
    }
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    _listeningTimer?.cancel();
    _isListening = false;
    _lastWords = '';
    _confidence = 0.0;
    notifyListeners();

    if (kDebugMode) {
      print('Cancelled listening (mock mode)');
    }
  }

  /// Speak text using TTS (mock implementation)
  Future<void> speak(String text) async {
    if (!_isAvailable || text.trim().isEmpty) return;
    
    _isSpeaking = true;
    notifyListeners();

    if (kDebugMode) {
      print('Speaking (mock mode): $text');
    }

    // Simulate speaking duration based on text length
    final duration = Duration(milliseconds: (text.length * 50).clamp(1000, 5000));
    
    _speechTimer = Timer(duration, () {
      _isSpeaking = false;
      notifyListeners();
      
      if (kDebugMode) {
        print('Finished speaking (mock mode)');
      }
    });
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    _speechTimer?.cancel();
    _isSpeaking = false;
    notifyListeners();

    if (kDebugMode) {
      print('Stopped speaking (mock mode)');
    }
  }

  /// Set speech recognition locale (mock implementation)
  Future<void> setLocale(String localeId) async {
    // Mock implementation - just acknowledge the change
    if (kDebugMode) {
      print('Locale set to: $localeId (mock mode)');
    }
    notifyListeners();
  }

  /// Get supported locales for speech recognition (mock implementation)
  Future<List<Map<String, String>>> getSupportedLocales() async {
    // Return mock locale list
    return [
      {'localeId': 'en_US', 'name': 'English (US)'},
      {'localeId': 'es_ES', 'name': 'Spanish (Spain)'},
      {'localeId': 'fr_FR', 'name': 'French (France)'},
      {'localeId': 'de_DE', 'name': 'German (Germany)'},
    ];
  }

  /// Check if speech recognition is currently available
  bool get hasRecognitionSupport => _isAvailable;

  /// Get current error status
  String get lastError => ''; // No errors in mock mode

  /// Reset the provider state
  void reset() {
    _listeningTimer?.cancel();
    _speechTimer?.cancel();
    _isListening = false;
    _lastWords = '';
    _confidence = 0.0;
    _isSpeaking = false;
    notifyListeners();
  }

  /// Check microphone permission status (mock implementation)
  Future<bool> checkMicrophonePermission() async {
    return true; // Always granted in mock mode
  }

  /// Quick voice command detection
  bool isVoiceCommand(String text) {
    final commands = [
      'send message',
      'create task',
      'call',
      'open',
      'navigate',
      'help',
      'settings',
      'schedule',
      'update',
      'add',
      'share',
    ];
    
    final lowerText = text.toLowerCase();
    return commands.any((command) => lowerText.contains(command));
  }

  /// Process voice command (mock implementation)
  String processVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();
    
    if (lowerCommand.contains('create') && lowerCommand.contains('task')) {
      return 'Creating a new task...';
    } else if (lowerCommand.contains('send') && lowerCommand.contains('message')) {
      return 'Opening message composer...';
    } else if (lowerCommand.contains('schedule') && lowerCommand.contains('meeting')) {
      return 'Scheduling a meeting...';
    } else if (lowerCommand.contains('call')) {
      return 'Initiating call...';
    } else {
      return 'Command recognized: $command';
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _listeningTimer?.cancel();
    _speechTimer?.cancel();
    super.dispose();
  }
}
