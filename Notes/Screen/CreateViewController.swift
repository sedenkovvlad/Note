//
//  CreateViewController.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit


protocol CreateViewControllerDelegate: class {
    func saveNotes(didFinishAdditing note: Note)
    func saveNotes(didFinishEditing note: Note)
}

class CreateViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    weak var delegate: CreateViewControllerDelegate?
    weak var noteToEdit: Note?
    

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addNote))
        setupViewController()
    }
}


//MARK: Actions
extension CreateViewController {
    @objc private func addNote() {
        guard let text = textField.text else { return }
        if let noteToEdit = noteToEdit {
            noteToEdit.text = text
            noteToEdit.date = Date()
            delegate?.saveNotes(didFinishEditing: noteToEdit)
        } else {
            let addNote = Note(text: text, date: Date())
            delegate?.saveNotes(didFinishAdditing: addNote)
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Helpers Function
extension CreateViewController {
    func setupViewController() {
        textField.becomeFirstResponder()
        if let note = noteToEdit {
            textField.text = note.text
            title = "Edit Note"
        } else {
            title = "Add Note"
        }
    }
}
