//
//  CreateViewController.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addNote))
    }
    



}


//MARK: Actions

extension CreateViewController {
    
    @objc private func addNote() {
        
    }
}
