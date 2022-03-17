//
//  DetailNotesVC.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import UIKit

class DetailNotesVC: UIViewController {
    
    var managerCoreData = MаnagerCoreData()
    
    var notes: Notes? = nil
    
    var imageData: [Data] = []
    
    let date = Date()
    
    @IBOutlet weak var dateNavigationBar: UIBarButtonItem!
    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBOutlet weak var addPhoto: UIView!
    
    @IBOutlet weak var colletionView: UICollectionView!
    
    @IBOutlet weak var shadowViewCV: UIView!
    
    //MARK: ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colletionView.dataSource = self
        colletionView.delegate = self
        
        settingDataVC()
        
        settingIsHiddenCV()
        
        hideKeybboardTapView()
        
        settingTitleTF()
        
        addPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAlert)))
        
        CustomView.addViewRadius(views: [titleTF, descriptionTV, addPhoto, colletionView, shadowViewCV], radius: 10)
    }
    
    //MARK: button
    @IBAction func backVC(_ sender: Any) {
        managerCoreData.saveNotes(note: notes ?? nil, date: date, imageData: imageData, titleTF: titleTF, descriptionTV: descriptionTV)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func openAlert(){
        settingImageAlert()
    }
    
    //MARK: SettingVC
    func settingIsHiddenCV() {
        if imageData.isEmpty {
            colletionView.isHidden = true
            shadowViewCV.isHidden = true
        } else {
            colletionView.isHidden = false
            shadowViewCV.isHidden = false
            CustomView.shadowCellSetings(with: shadowViewCV)
            shadowViewCV.layer.shouldRasterize = true
            shadowViewCV.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    func settingDataVC() {
        if notes != nil {
            titleTF.text = notes?.tittelNotes
            descriptionTV.text = notes?.descriptionNotes
            dateNavigationBar.title = CustomView.dateFormatter.string(from: notes!.date!)
        } else {
            dateNavigationBar.title = CustomView.dateFormatter.string(from: date)
        }
        dateNavigationBar.isEnabled = false
    }
    
    func settingTitleTF(){
        let redPlaceholderText = NSAttributedString(string: "Название заметки...",
                                                    attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.984313786, green: 0.984313786, blue: 0.984313786, alpha: 1)])
        
        titleTF.attributedPlaceholder = redPlaceholderText
    }
}

//MARK: UICollectionViewDataSource
extension DetailNotesVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCellDetailNotesVC
        
        settingIsHiddenCV()
        
        let wayImageData = imageData[indexPath.item]
        
        collectionCell.delePhoto = { [weak self] in
            guard let self = self else {return}
            self.imageData.remove(at: indexPath.item)
            self.settingIsHiddenCV()
            self.colletionView.reloadData()
        }
        
        collectionCell.imageCollectionViewCell.image = UIImage(data: wayImageData)
        collectionCell.imageCollectionViewCell.isUserInteractionEnabled = true
        
        collectionCell.tapped = { [weak self] in
            self?.tappedPhoroCV(collectionView, didSelectItemAt: indexPath)
        }
        
        return collectionCell
    }
}

//MARK: UICollectionViewDelegate
// Я понимаю что для перехода есть didSelectItem, но по не известной мне причине он не вызывался и я не смог это пофиксить ( оказалось что довольно частая проблема ) и решил прикрутить небольшое свое решение
extension DetailNotesVC: UICollectionViewDelegate {
    func tappedPhoroCV(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wayImage = imageData[indexPath.row]
        let storyboard = UIStoryboard(name: "DetailNotesView", bundle: nil)
        let detailImageVC = storyboard.instantiateViewController(identifier: "detailImageVC") as? DetailImageVC
        detailImageVC?.image = wayImage
        self.navigationController?.pushViewController(detailImageVC!, animated: true)
    }
}


//MARK: Alert
extension DetailNotesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func settingImageAlert() {
        
        let allertImage = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Сделать фото", style: .default) {_ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.settingAllertImage(source: .camera)
            }
        }
        
        let gallery = UIAlertAction(title: "Установить из галереи", style: .default) {_ in
            self.settingAllertImage(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        
        allertImage.addAction(photo)
        allertImage.addAction(gallery)
        allertImage.addAction(cancel)
        self.present(allertImage, animated: true, completion: nil)
    }
    
    func settingAllertImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let settingImage = UIImagePickerController()
            settingImage.delegate = self
            settingImage.allowsEditing = true
            settingImage.sourceType = source
            present(settingImage, animated: true)
        }
    }
    // MARK: add photo in array
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let result = info[.editedImage] as? UIImage else { return }
        let data = result.pngData()
        imageData.append(data!)
        colletionView.reloadData()
        dismiss(animated: true)
    }
}
