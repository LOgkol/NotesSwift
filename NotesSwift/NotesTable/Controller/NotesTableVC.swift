//
//  NotesTableVC.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import UIKit
import CoreData

class NotesTableVC: UIViewController {
    
    private  lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var mаnagerCoreData = MаnagerCoreData()
        
    private var notes: [Notes] = []
    
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    let identifierCell = "NotesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
// необходимо для ТЗ, т.к сказано что при первом запуске приложение должно иметь одну заметку с текстом
        let checkOneStart = userDefaults.getCheckValue()
        if checkOneStart == 0 {
            mаnagerCoreData.oneStarNotes()
            userDefaults.setCheckValue(value: 1)
        }
        
        mаnagerCoreData.readingNotesCoreData { [weak self] notes in
            guard let self = self, let notes = notes else { return }
            self.notes = notes
            print(self.notes)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addNotes(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DetailNotesView", bundle: nil)
        let detailsNotes = storyboard.instantiateViewController(withIdentifier: "detailNotesVC")
        self.navigationController?.pushViewController(detailsNotes, animated: true)
    }
}

//MARK: TableViewDataSource
extension NotesTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let note = notes[indexPath.row]
        
        mаnagerCoreData.deleteNoteTableVC(note: note) { [weak self] notes in
            guard let self = self, let notes = notes else { return }
            self.notes = notes
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell) as! NotesCustomCell
        
        let notesWay = notes[indexPath.row]
        
        let image = notes[indexPath.row].imageNotes as! [Data]
        
        if image.isEmpty {
            cell.collectionView.isHidden = true
        } else {
            cell.collectionView.isHidden = false
            cell.image = image
            cell.collectionView.reloadData()
        }
        
        if notesWay.tittelNotes!.isEmpty {
            cell.titleCell.isHidden = true
        } else {
            cell.titleCell.isHidden = false
            cell.titleCell.text = notesWay.tittelNotes
        }
        
        if notesWay.descriptionNotes!.isEmpty {
            cell.discriptionCell.isHidden = true
        } else {
            cell.discriptionCell.isHidden = false
            cell.discriptionCell.text = notesWay.descriptionNotes
        }
        
        cell.tappedPhoto = {
            self.tappedPhoto(tableView, didSelectRowAt: indexPath)
        }
        
        cell.dateCell.text = CustomView.dateFormatter.string(from: notesWay.date!)
        
        cell.shadowView.layer.shouldRasterize = true
        cell.shadowView.layer.rasterizationScale = UIScreen.main.scale
        CustomView.shadowCellSetings(with: cell.shadowView)
        
        return cell
    }
}

//MARK: TableViewDelegate
extension NotesTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailNotesView", bundle: nil)
        let detailsNotes = storyboard.instantiateViewController(withIdentifier: "detailNotesVC") as! DetailNotesVC
        detailsNotes.notes = notes[indexPath.row]
        detailsNotes.imageData = notes[indexPath.row].imageNotes as! [Data]
        self.navigationController?.pushViewController(detailsNotes, animated: true)
    }
    
    func tappedPhoto(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "DetailNotesView", bundle: nil)
        let detailsNotes = storyboard.instantiateViewController(withIdentifier: "detailNotesVC") as! DetailNotesVC
        detailsNotes.notes = notes[indexPath.row]
        detailsNotes.imageData = notes[indexPath.row].imageNotes as! [Data]
        self.navigationController?.pushViewController(detailsNotes, animated: true)
    }
}
