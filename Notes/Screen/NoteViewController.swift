//
//  ViewController.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    private lazy var notes = [Note]()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushCreateController))
    }
}

//MARK: TableViewDataSource
extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        let split = note.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        cell.titleLabel.text = getTitleText(split: split)
        cell.subtitleLabel.text = getSubtitleText(split: split)
        cell.dateLabel.text = dateFormat(from: note.date)
        return cell
    }
}
//MARK: TableViewDelegate
extension NoteViewController: UITableViewDelegate {
    
}

//MARK: Navigation
extension NoteViewController {
    @objc private func pushCreateController(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: CreateViewControllerDelegate
extension NoteViewController: CreateViewControllerDelegate {
    func saveNotes(didFinishAdditing note: Note) {
        self.notes.append(note)
        navigationController?.popViewController(animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.tableVIew.reloadData()
        }
    }
}

//MARK: Helpers
extension NoteViewController {
    //text split
    func getTitleText(split: [Substring]) -> String {
        if split.count >= 1 {
            return String(split[0])
        }
        return "New Note"
    }
    
    func getSubtitleText(split: [Substring]) -> String {
        if split.count >= 2 {
            return String(split[1])
        }
        
        return "No Subtitle text"
    }
    //date formatter
    func dateFormat(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
}

