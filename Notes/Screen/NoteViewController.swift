//
//  ViewController.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

//MARK: TableViewDataSource
extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        return cell
    }
}
//MARK: TableViewDelegate
extension NoteViewController: UITableViewDelegate {
    
}

