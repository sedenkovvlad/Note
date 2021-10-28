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
    
    //button
    private lazy var addButton = UIButton()
    private lazy var editButton = UIBarButtonItem()
    private lazy var cancelButton = UIBarButtonItem()
    private lazy var spacerButton = UIBarButtonItem()
    private lazy var deleteAllButton = UIBarButtonItem()
    private lazy var deleteButton = UIBarButtonItem()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddButton()
        updateData()
        configureNavigationBar()
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
        cell.configure(at: note)
        return cell
    }
}
//MARK: TableViewDelegate
extension NoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            toolbarItems = [spacerButton, deleteButton]
        } else {
            pushCreateController()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow == nil || tableView.indexPathForSelectedRow!.isEmpty {
            toolbarItems = [spacerButton, deleteAllButton]
        }
    }
    
}

//MARK: StorageManager
extension NoteViewController {
    private func updateData() {
        DispatchQueue.global().async { [weak self] in
            self?.notes = StorageManager.load()
            DispatchQueue.main.async {
                self?.sortNotes()
                self?.tableView.reloadData()
            }
        }
    }
    private func saveData() {
        DispatchQueue.global().async { [weak self] in
            StorageManager.save(notes: self?.notes)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: CreateViewControllerDelegate
extension NoteViewController: CreateViewControllerDelegate {
    func saveNotes(didFinishAdditing note: Note) {
        self.notes.append(note)
        sortNotes()
        saveData()
    }
    func saveNotes(didFinishEditing note: Note) {
        if let index = notes.firstIndex(of: note) {
            let indexPath = IndexPath(row: index, section: 0)
            notes[indexPath.row] = note
            sortNotes()
        }
        saveData()
    }
}

//MARK: EditMode
extension NoteViewController {
    @objc private func enterEditingMode() {
        navigationItem.rightBarButtonItems = [cancelButton]
        navigationController?.isToolbarHidden = false
        toolbarItems = [spacerButton, deleteAllButton]
        addButton.removeFromSuperview()
        tableView.setEditing(true, animated: true)
    }
    
    @objc private func cancelEditingMode() {
        navigationItem.rightBarButtonItems = [editButton]
        navigationController?.isToolbarHidden = true
        configureAddButton()
        tableView.setEditing(false, animated: true)
    }
    
    @objc private func deleteAllNotes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete All", style: .destructive) { [weak self] _ in
            self?.notes.removeAll()
            self?.saveData()
            self?.cancelEditingMode()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    @objc private func deleteSelectedNotes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete Selected", style: .destructive) { [weak self] _ in
            if let rows = self?.tableView.indexPathsForSelectedRows {
                let sortedArray = rows.sorted { $0.row < $1.row }
                for i in (0...sortedArray.count - 1).reversed() {
                    self?.notes.remove(at: sortedArray[i].row)
                }
            }
            self?.cancelEditingMode()
            self?.saveData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}



//MARK: Navigation
extension NoteViewController {
    @objc private func pushCreateController() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateViewController
        vc.delegate = self
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.noteToEdit = notes[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ScrollViewDelegate
extension NoteViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        addButton.isHidden = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addButton.isHidden = false
    }
}

//MARK: Helpers
extension NoteViewController {
    private func configureAddButton() {
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
    
    private func configureNavigationBar() {
        //navigation bar
        editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(enterEditingMode))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector((cancelEditingMode)))
        navigationItem.rightBarButtonItems = [editButton]
        //toolbar
        spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        deleteAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllNotes))
        deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteSelectedNotes))
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    private func sortNotes() {
        notes.sort { $0.date > $1.date }
    }
}



