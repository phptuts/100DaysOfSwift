//
//  ViewController.swift
//  Day74ChallengeNotes
//
//  Created by Noah Glaser on 1/23/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notes = getSortedNotes()
        let currentNotify = NotificationCenter.default
        currentNotify.addObserver(self, selector: #selector(freshNotes), name: Notification.Name("NotesSaved"), object: nil)
    }
    
    func getSortedNotes() -> [Note] {
        return getNotes().sorted(by: {
            $0.lastEditted.compare($1.lastEditted) == .orderedDescending
        })
    }
    
    @objc func freshNotes() {
        notes = getSortedNotes()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "note") else {
            fatalError("No cell with identifier notes")
        }
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].printDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NoteView") as? NoteViewController else { return }
        
        vc.note = notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(note: notes[indexPath.row])
            notes = getSortedNotes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

