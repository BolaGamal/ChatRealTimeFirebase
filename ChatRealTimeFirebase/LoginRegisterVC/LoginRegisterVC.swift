//
//  ViewController.swift
//  ChatRealTimeFirebase
//
//  Created by mac on 30/10/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class LoginRegisterVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToHomeScreen()
    }
    
    func saveUserNameById(userId:String, userName:String){
        let dataArr:[String:Any] = ["username":userName]
        ref.child("users").child(userId).setValue(dataArr)
    }
    
    
    func login(email:String, password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.displayError(errorText: error.localizedDescription)
            }else {
                self.goToHomeScreen()
                print("Login succesfully")
            }
        }
    }
    
    func register(email:String, password:String, userName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.displayError(errorText: error.localizedDescription)
            }else {
                guard let userId = result?.user.uid else {return}
                self.saveUserNameById(userId: userId, userName: userName)
                self.goToHomeScreen()
                print("Register succesfully")
            }
        }
    }
    
}


extension LoginRegisterVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LoginRegisterCell
        
        if indexPath.row == 0 { // MARK: Login
            cell.userNameTF.isHidden = true
            cell.actionButton.setTitle("Login", for: .normal)
            cell.slideButton.setTitle("Register", for: .normal)
            cell.action = {
                guard let email = cell.emailTF.text,
                      let password = cell.passwordTF.text,
                      !email.isEmpty, !password.isEmpty else { return }
                
                self.login(email: email, password: password)
            }
            
            cell.slide = {
                collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: [.centeredHorizontally], animated: true)
            }
            
        }else if indexPath.row == 1 { // MARK: Register
            cell.userNameTF.isHidden = false
            cell.actionButton.setTitle("Register", for: .normal)
            cell.slideButton.setTitle("Login", for: .normal)
            cell.action = {
                guard let email = cell.emailTF.text,
                      let password = cell.passwordTF.text,
                      let userName = cell.userNameTF.text,
                      !email.isEmpty, !password.isEmpty,
                      !userName.isEmpty else { return }
                
                self.register(email: email, password: password, userName: userName)
            }
            
            cell.slide = {
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: [.centeredHorizontally], animated: true)
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}


extension LoginRegisterVC {
    
    func goToHomeScreen() {
        if Auth.auth().currentUser != nil {
            let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
            let vc = HomeVC(nibName: "HomeVC", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        
        //        if UserDefaults.standard.bool(forKey: "LoggedIn") == false {
        //            let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        //            let nav = UINavigationController(rootViewController: vc)
        //            window?.rootViewController = nav
        //            window?.makeKeyAndVisible()
        //        } else if UserDefaults.standard.bool(forKey: "LoggedIn") == true {
        //            let storyboard = UIStoryboard(name: "Main", bundle:nil)
        //            let vc = storyboard.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterVC
        //            window?.rootViewController = vc
        //            window?.makeKeyAndVisible()
        //        }
    }
    
}

extension UIViewController {
    func displayError(errorText:String) {
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
