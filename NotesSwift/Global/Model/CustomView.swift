//
//  CustomView.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//

import Foundation
import UIKit


class CustomView {
    
    public static func addViewRadius(views: [UIView], radius: CGFloat){
        for view in views{
            view.layer.cornerRadius = radius
        }
    }
    
    public static func shadowCellSetings(with cellShadowView: UIView) {
        cellShadowView.layer.shadowOffset = .zero
        cellShadowView.layer.shadowColor = UIColor.white.cgColor
        cellShadowView.layer.shadowRadius = 8
        cellShadowView.layer.shadowOpacity = 0.5
        cellShadowView.layer.masksToBounds = false
        cellShadowView.clipsToBounds = false
    }
    
    public static var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy   HH:mm"
      return formatter
    }()
}

extension UIViewController {
    
    func hideKeybboardTapView() {
        let tapMainView = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapMainView)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 200
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

enum UserDefaultsKeys : String {
    case checkValue
}

extension UserDefaults{

    func setCheckValue(value: Int){
        set(value, forKey: UserDefaultsKeys.checkValue.rawValue)
    }

    func getCheckValue() -> Int{
        return integer(forKey: UserDefaultsKeys.checkValue.rawValue)
    }
}
