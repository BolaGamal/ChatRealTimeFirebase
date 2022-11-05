//
//  LoginRegisterCell.swift
//  ChatRealTimeFirebase
//
//  Created by mac on 30/10/2022.
//

import UIKit

class LoginRegisterCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var slideButton: UIButton!
    
    var action: (()->())?
    var slide: (()->())?
    
    
    @IBAction func login(_ sender: Any) {
        action?()
    }

    @IBAction func register(_ sender: Any) {
        slide?()
    }
    
}
