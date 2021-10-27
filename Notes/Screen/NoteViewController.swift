//
//  ViewController.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit
import ShimmerSwift

class NoteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private lazy var notes = [Note]()
    private lazy var addButton = UIButton()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddButton()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushCreateController()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Navigation
extension NoteViewController {
    @objc private func pushCreateController(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateViewController
        vc.delegate = self
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.noteToEdit = notes[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: CreateViewControllerDelegate
extension NoteViewController: CreateViewControllerDelegate {
    func saveNotes(didFinishAdditing note: Note) {
        self.notes.append(note)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    func saveNotes(didFinishEditing note: Note) {
        if let index = notes.firstIndex(of: note) {
            let indexPath = IndexPath(row: index, section: 0)
            notes[indexPath.row] = note
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
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
    
    func sortNotes() {
        notes.sort { $0.date > $1.date }
    }
    
}


//MARK: UI

extension NoteViewController {
    func configureAddButton() {
        addButton = AddButton(frame: CGRect(x: view.frame.width - 80, y: view.frame.height - 90, width: 50, height: 50))
        addButton.addTarget(self, action: #selector(pushCreateController), for: .touchUpInside)
        view.addSubview(addButton)
        let shimmerView = ShimmeringView(frame: addButton.frame)
        view.addSubview(shimmerView)
        shimmerView.contentView = addButton
        shimmerView.shimmerSpeed = 30
        shimmerView.shimmerDirection = .up
        shimmerView.isShimmering = true
    }
}

