//
//  CollectionCellNotesTable.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import UIKit

class CollectionCellNotesTable: UICollectionViewCell {
    
    @IBOutlet weak var imageCollectionViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CustomView.addViewRadius(views: [imageCollectionViewCell], radius: 10)
    }
}
