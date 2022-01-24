//
//  Note.swift
//  Day74ChallengeNotes
//
//  Created by Noah Glaser on 1/23/22.
//

import Foundation
import UserNotifications

struct Note: Codable {
    
    init(note: String) {
        self.note = note
        self.lastEditted = Date()
        self.id = UUID().uuidString
    }
    
    var id: String
    var lastEditted: Date

    var note: String {
        didSet {
            lastEditted = Date()
        }
    }
    var title: String {
        return String(note.split(separator: "\n").first ?? "No Title")
    }
    
    var printDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: lastEditted)
    }
}

func deleteNote(note: Note) {
    var notes = getNotes()
    notes = notes.filter({ $0.id != note.id })
    saveNoteUserDefaults(notes: notes)
}


func saveNote(note: Note) {
    var notes = getNotes()
    notes = notes.filter({ $0.id != note.id })
    notes.append(note)
    saveNoteUserDefaults(notes: notes)
    let currentNotify = NotificationCenter.default
    let notification = Notification(name: Notification.Name("NotesSaved"), object: nil, userInfo: nil)
    currentNotify.post(notification)
}

func saveNoteUserDefaults(notes: [Note]) {
    let encoder = JSONEncoder()
    if let notesJSON = try? encoder.encode(notes) {
        let defaults = UserDefaults.standard
        defaults.set(notesJSON, forKey: "notes")
    }
}

func getNotes() -> [Note] {
    let defaults = UserDefaults.standard
    if let data = defaults.object(forKey: "notes") as? Data {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Note].self, from: data)
        } catch {
            fatalError("Error Count Not Decode Notes")
        }
    }
    
    return []
}
