import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/splash/loading_screen.dart';
import 'providers/voice_provider.dart';
import 'providers/channel_provider.dart';
import 'providers/task_provider.dart';

/// Main entry point of the application
void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations and system UI
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Hide system UI for full-screen experience
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  
  // Run the app
  runApp(const AIAssistantApp());
}

/// Root widget of the AI Assistant application
/// 
/// This widget configures the app's theme, routes, and initial screen.
/// It follows Material Design 3 principles and supports both light and dark themes.
class AIAssistantApp extends StatelessWidget {
  const AIAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VoiceProvider()),
        ChangeNotifierProvider(create: (_) => ChannelProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..initializeSampleTasks()),
      ],
      child: MaterialApp(
        // App configuration
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        
        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        
        // Initial screen
        home: const LoadingScreen(),
        
        // Error handling and responsive design
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0), // Prevent text scaling issues
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
