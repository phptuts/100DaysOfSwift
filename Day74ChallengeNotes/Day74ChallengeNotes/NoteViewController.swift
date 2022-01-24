//
//  NoteViewController.swift
//  Day74ChallengeNotes
//
//  Created by Noah Glaser on 1/23/22.
//

import UIKit

class NoteViewController: UIViewController {

    var note: Note!
    
    @IBOutlet var noteTextEditor: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            title = "Edit \(note!.title)"
            noteTextEditor.text = note.note
        } else {
            title = "New Note"
            note = Note(note: "")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNote), name: UIWindow.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    

    @objc func updateNote() {
        
        note.note = noteTextEditor.text
        
        let currentNotify = NotificationCenter.default
        let notification = Notification(name: Notification.Name("EditNote"), object: nil, userInfo: ["note": note!])
        currentNotify.post(notification)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
