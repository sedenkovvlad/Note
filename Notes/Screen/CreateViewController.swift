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
    
    lazy var doneButton = UIBarButtonItem()
    lazy var saveButton = UIBarButtonItem()
    weak var delegate: CreateViewControllerDelegate?
    weak var noteToEdit: Note?
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addNote))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideKeyboard))
        navigationItem.rightBarButtonItems = [saveButton]
        setupViewController()
        notification()
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

//MARK: Hide Keyboard
extension CreateViewController {
    
    private func notification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textField.contentInset = .zero
            navigationItem.rightBarButtonItems = [saveButton]
            
        }
        else {
            textField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            navigationItem.rightBarButtonItems = [doneButton, saveButton]        }
        
        textField.scrollIndicatorInsets = textField.contentInset
        let selectedRange = textField.selectedRange
        textField.scrollRangeToVisible(selectedRange)
    }
    
    @objc private func hideKeyboard() {
        textField.endEditing(true)
    }
    
    
    
}
