import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/notes_bloc.dart';
import 'bloc/notes_event.dart';
import 'data/models/note.dart';
import 'data/repositories/note_repository.dart';
import 'presentation/pages/notes_page.dart';
import 'presentation/pages/notes_detail_page.dart';
import 'presentation/pages/notes_edit_page.dart';
import 'presentation/pages/gyro_page.dart';
import 'services/gyro_service.dart';

class AppConfig {
  static const String appTitle = 'Notes App';

  static const double defaultElevation = 2.0;
  static const double noElevation = 0.0;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init gyro service
  try {
    final gyroData = await GyroService.getGyroData();
    if (kDebugMode) {
      debugPrint('Gyro Data from platform channel: $gyroData');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Error getting gyro data: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NoteRepository>(
          create: (context) => NoteRepository(),
        ),
        RepositoryProvider<GyroService>(
          create: (context) => GyroService(),
        ),
      ],
      child: BlocProvider(
        create: (context) {
          final noteRepository = context.read<NoteRepository>();
          return NotesBloc(repository: noteRepository)..add(LoadNotes());
        },
        child: MaterialApp(
          title: AppConfig.appTitle,
          debugShowCheckedModeBanner: false,
          theme: _buildAppTheme(),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                builder: (context) => const NotesPage(),
              );
            }
            
            if (settings.name == '/detail') {
              final note = settings.arguments as Note;
              return MaterialPageRoute(
                builder: (context) => NotesDetailPage(note: note),
              );
            }
            
            if (settings.name == '/edit') {
              final note = settings.arguments as Note;
              return MaterialPageRoute(
                builder: (context) => NotesEditPage(note: note),
              );
            }

            if (settings.name == '/gyro') {
              return MaterialPageRoute(
                builder: (context) => const GyroPage(),
              );
            }
            
            return null;
          },
        ),
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF252525),
      colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(255, 255, 255, 255),
        secondary: Color(0xFF3D3D3D),
        onSurface: Color.fromARGB(255, 255, 255, 255),
        surface: Color(0xFF252525),
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: AppConfig.noElevation,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF252525),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF3D3D3D),
        foregroundColor: Colors.white,
        elevation: AppConfig.defaultElevation,
      ),
    );
  }
}
