import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenity_tasks/utils/note.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Speichern einer Notiz für einen Benutzer
  Future<void> saveNote(String userId, Note note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set({
      'content': note.content,
      'date': Timestamp.fromDate(note.date),
      'isArchived': false, // Standardmäßig nicht archiviert
      'isFavorite': false, // Standardmäßig nicht favorisiert
    });
  }

  // Aktualisieren des Inhalts einer Notiz
  Future<void> updateNoteContent(
      String userId, String noteId, String content) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({'content': content});
  }

  // Löschen einer Notiz
  Future<void> deleteNote(String userId, String noteId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  // Abrufen aller Notizen eines Benutzers
  Future<List<Note>> getNotes(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();

    return _mapSnapshotToNotes(snapshot);
  }

  // Stream von Notizen eines Benutzers (automatische Updates)
  Stream<List<Note>> getNotesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('date', descending: false)
        .snapshots()
        .map(_mapSnapshotToNotes);
  }

  // Suchen von Notizen basierend auf einer Abfrage
  Future<List<Note>> searchNotes(String userId, String query) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .where('content', isGreaterThanOrEqualTo: query)
        .where('content', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return _mapSnapshotToNotes(snapshot);
  }

  // Archivieren oder Entarchivieren einer Notiz
  Future<void> archiveNote(
      String userId, String noteId, bool isArchived) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({'isArchived': isArchived});
  }

  // Abrufen archivierter Notizen
  Future<List<Note>> getArchivedNotes(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .where('isArchived', isEqualTo: true)
        .get();

    return _mapSnapshotToNotes(snapshot);
  }

  // Markieren oder Entmarkieren einer Notiz als Favorit
  Future<void> markNoteAsFavorite(
      String userId, String noteId, bool isFavorite) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({'isFavorite': isFavorite});
      } else {
        print("Note with ID $noteId does not exist.");
      }
    } catch (e) {
      print("Error updating note: $e");
    }
  }

  // Abrufen der Favoriten-Notizen
  Future<List<Note>> getFavoriteNotes(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .where('isFavorite', isEqualTo: true)
        .get();

    return _mapSnapshotToNotes(snapshot);
  }

  // Hilfsfunktion zum Mapping der Daten aus Firestore in eine Liste von Notizen
  List<Note> _mapSnapshotToNotes(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final dateField = data['date'];
      DateTime date;

      if (dateField is Timestamp) {
        date = dateField.toDate();
      } else if (dateField is String) {
        date = DateTime.parse(dateField);
      } else {
        date = DateTime.now();
      }

      return Note(
        id: doc.id,
        content: data['content'] ?? '',
        date: date,
      );
    }).toList();
  }
}
