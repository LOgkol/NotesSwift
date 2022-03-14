//
//  CollectionViewCellDetailNotesVC.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import UIKit

class CollectionViewCellDetailNotesVC: UICollectionViewCell {
    
    @IBOutlet weak var imageCollectionViewCell: UIImageView!
    
    @IBOutlet weak var deleteImage: UIButton?
    
    @IBAction func deleteImage(_ sender: Any) {
        delePhoto?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageCollectionViewCell.layer.cornerRadius = 10
        
        deleteImage?.layer.cornerRadius = 10
        deleteImage?.clipsToBounds = true
        
        imageCollectionViewCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedImage)))
    }
    
    @objc func tappedImage() {
        tapped?()
    }
    
    var tapped: (() -> ())?
    
    var delePhoto: (() -> ())?
}
