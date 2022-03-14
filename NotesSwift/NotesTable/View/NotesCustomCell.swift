//
//  NotesCustomCell.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import UIKit

class NotesCustomCell: UITableViewCell {

    var image: [Data] = []
    
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var discriptionCell: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CustomView.addViewRadius(views: [shadowView], radius: 10)
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func test() {
        tappedPhoto?()
    }
    
    var tappedPhoto: (() -> ())?
}

extension NotesCustomCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCellNotesTable
        
        let way = image[indexPath.row]
        collectionCell.imageCollectionViewCell.image = UIImage(data: way)
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(test)))
        
        return collectionCell
    }
}
