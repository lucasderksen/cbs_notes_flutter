import 'package:flutter_test/flutter_test.dart';
import 'package:cbs_notes_flutter/data/models/note.dart';

void main() {
  final DateTime testDate = DateTime(2024, 1, 1, 12, 0);
  final testNote = Note(
    id: 'test-id',
    title: 'Test Title',
    content: 'Test Content',
    createdAt: testDate,
  );

  group('Note', () {
    test('creates Note instance with required parameters', () {
      expect(testNote.id, equals('test-id'));
      expect(testNote.title, equals('Test Title'));
      expect(testNote.content, equals('Test Content'));
      expect(testNote.createdAt, equals(testDate));
    });

    test('converts Note to Map correctly', () {
      final map = testNote.toMap();
      
      expect(map['id'], equals('test-id'));
      expect(map['title'], equals('Test Title'));
      expect(map['content'], equals('Test Content'));
      expect(map['createdAt'], equals(testDate.toIso8601String()));
    });

    test('creates Note from Map correctly', () {
      final map = {
        'id': 'test-id',
        'title': 'Test Title',
        'content': 'Test Content',
        'createdAt': testDate.toIso8601String(),
      };

      final note = Note.fromMap(map);
      
      expect(note.id, equals('test-id'));
      expect(note.title, equals('Test Title'));
      expect(note.content, equals('Test Content'));
      expect(note.createdAt, equals(testDate));
    });

    test('copyWith returns new instance with updated values', () {
      final updatedNote = testNote.copyWith(
        title: 'New Title',
        content: 'New Content',
      );

      expect(updatedNote.id, equals(testNote.id));
      expect(updatedNote.title, equals('New Title'));
      expect(updatedNote.content, equals('New Content'));
      expect(updatedNote.createdAt, equals(testNote.createdAt));
      
      // Original note should remain unchanged
      expect(testNote.title, equals('Test Title'));
      expect(testNote.content, equals('Test Content'));
    });

    test('props contains all properties', () {
      expect(testNote.props, equals([
        testNote.id,
        testNote.title,
        testNote.content,
        testNote.createdAt,
      ]));
    });

    test('toString returns correct string representation', () {
      expect(
        testNote.toString(),
        equals('Note{id: test-id, title: Test Title, content: Test Content, createdAt: $testDate}'),
      );
    });

    test('equality comparison works correctly', () {
      final note1 = Note(
        id: 'id',
        title: 'title',
        content: 'content',
        createdAt: testDate,
      );

      final note2 = Note(
        id: 'id',
        title: 'title',
        content: 'content',
        createdAt: testDate,
      );

      final note3 = Note(
        id: 'different',
        title: 'title',
        content: 'content',
        createdAt: testDate,
      );

      expect(note1, equals(note2));
      expect(note1, isNot(equals(note3)));
    });
  });
}