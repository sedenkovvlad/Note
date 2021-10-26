//
//  CreateViewController.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit


protocol CreateViewControllerDelegate: class {
    func saveNotes(didFinishAdditing note: Note)
}

class CreateViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    weak var delegate: CreateViewControllerDelegate?
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addNote))
    }
}


//MARK: Actions
extension CreateViewController {
    @objc private func addNote() {
        guard let text = textField.text else { return }
        let note = Note(text: text, date: Date())
        delegate?.saveNotes(didFinishAdditing: note)
    }
}
