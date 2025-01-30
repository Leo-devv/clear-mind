import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JournalEntry {
  final String id;
  final String content;
  final DateTime date;
  final String mood;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.content,
    required this.date,
    required this.mood,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'date': date.toIso8601String(),
        'mood': mood,
        'tags': tags,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'],
        content: json['content'],
        date: DateTime.parse(json['date']),
        mood: json['mood'],
        tags: List<String>.from(json['tags']),
      );
}

class JournalService {
  static const String _entriesKey = 'journal_entries';

  static Future<List<JournalEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_entriesKey) ?? [];
    
    return entriesJson
        .map((json) => JournalEntry.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
  }

  static Future<void> addEntry(JournalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_entriesKey) ?? [];
    
    entriesJson.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_entriesKey, entriesJson);
  }

  static Future<void> updateEntry(JournalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_entriesKey) ?? [];
    
    final entries = entriesJson
        .map((json) => JournalEntry.fromJson(jsonDecode(json)))
        .toList();
    
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      entriesJson[index] = jsonEncode(entry.toJson());
      await prefs.setStringList(_entriesKey, entriesJson);
    }
  }

  static Future<void> deleteEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_entriesKey) ?? [];
    
    final entries = entriesJson
        .map((json) => JournalEntry.fromJson(jsonDecode(json)))
        .toList();
    
    entries.removeWhere((entry) => entry.id == id);
    
    final updatedEntriesJson = entries
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();
    
    await prefs.setStringList(_entriesKey, updatedEntriesJson);
  }
} 
