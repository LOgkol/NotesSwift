//
//  MаnagerCoreData.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import Foundation
import UIKit
import CoreData

class MаnagerCoreData {
    
    private  lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var notes: [Notes] = []
    
    func readingNotesCoreData(completion: @escaping ([Notes]?) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        do {
            notes = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        completion(notes)
    }
    
    func deleteNoteTableVC(note: Notes, complition: @escaping([Notes]?) -> Void) {
        
        context.delete(note)
        
        do {
            try context.save()
            readingNotesCoreData { [] notes in
                guard let notes = notes else { return }
                complition(notes)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func oneStarNotes() {
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        let newNotes = NSManagedObject(entity: entity!, insertInto: context) as! Notes
        
        var imageData: [Data] = []
        let image = UIImage(named: "imageApp")?.pngData()
        imageData.append(image!)
        
        let date = Date()
        newNotes.date = date
        newNotes.tittelNotes = "Название заметки"
        newNotes.descriptionNotes = "Это описание Вашей заметки\nА ниже может быть Ваша фотография, нажмите на ячейку таблицы чтобы перейти в редактор заметки\nТак же Вы можете нажать на фотографию, чтобы расмотреть ее немного детальнее\n\nЧтобы удалить заметку Вы должны вернуться на главный экран и смахнуть ее в лево"
        newNotes.imageNotes = imageData as NSObject?
        
        do {
            try context.save()
            print("good")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveNotes(note: Notes?, date: Date, imageData: [Data], titleTF: UITextField, descriptionTV: UITextView) {
        if note == nil {
            if imageData.isEmpty == false || validateTextField(textField: titleTF) || validateTextView(textView: descriptionTV){
                let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
                let newNotes = NSManagedObject(entity: entity!, insertInto: context) as! Notes
                
                newNotes.date = date
                newNotes.imageNotes = imageData as NSObject
                
                if validateTextField(textField: titleTF) {
                    newNotes.tittelNotes = titleTF.text
                } else {
                    newNotes.tittelNotes = ""
                }
                
                if validateTextView(textView: descriptionTV) {
                    newNotes.descriptionNotes = descriptionTV.text
                } else {
                    newNotes.descriptionNotes = ""
                }
                
                do {
                    try context.save()
                    print("good")
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            if imageData.isEmpty == false || validateTextField(textField: titleTF) || validateTextView(textView: descriptionTV) {
                note?.date = date
                note?.imageNotes = imageData as NSObject
                
                if validateTextField(textField: titleTF) {
                    note?.tittelNotes = titleTF.text
                } else {
                    note?.tittelNotes = ""
                }
                
                if validateTextView(textView: descriptionTV) {
                    note?.descriptionNotes = descriptionTV.text
                } else {
                    note?.descriptionNotes = ""
                }
                
                do{
                    try context.save()
                }catch {
                    print(error.localizedDescription)
                }
            } else {
                deleteNotes(note: note!)
            }
        }
    }
    
    func deleteNotes(note: Notes) {
        
        context.delete(note)
        
        do {
            try context.save()
            print("delete")
        } catch {
            print(error.localizedDescription)
        }
    }

    
    //проверка на пробелы и не заполненные поля
    func validateTextView(textView: UITextView) -> Bool {
        guard let text = textView.text,
              !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                  return false
              }
        return true
    }
    
    func validateTextField(textField textView: UITextField) -> Bool {
        guard let text = textView.text,
              !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                  return false
              }
        return true
    }
}
