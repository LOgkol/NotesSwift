//
//  DetailImageVC.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import UIKit

class DetailImageVC: UIViewController {

    var imageScrollView: ImageScrollView!
    
    var image: Data? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)

        let imageWay: UIImage = UIImage(data: image!)!
        
        self.imageScrollView.set(image: (imageWay))
        
        setupImageScrollView()
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}
