//
//  HomeVC.swift
//  ChatRealTimeFirebase
//
//  Created by mac on 30/10/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeVC: UIViewController {
    
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var roomsTableView: UITableView!
    @IBOutlet weak var roomNameTF: UITextField!
    
    var ref = Database.database().reference()
    var rooms = [Room]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeRooms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserNameById()
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        goToLoginScreen()
    }
    
    func setupViews() {
        title = "Chat Rooms"
        roomsTableView.register(UINib(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "RoomCell")
    }
    
    @IBAction func createRoom(_ sender: Any) {
        guard let roomName = roomNameTF.text, roomName.isEmpty == false else { return }
        createRoom(name: roomName)
    }
    
    func createRoom(name:String) {
        let dataArr: [String:Any] = ["room_name": name]
        ref.child("rooms").childByAutoId().setValue(dataArr) { error, dataRef in
            if let error = error {
                self.displayError(errorText: error.localizedDescription)
            }else {
                self.roomNameTF.text = ""
                print("Room created succesfully")
            }
        }
    }
    
    func observeRooms() {
        ref.child("rooms").observe(.childAdded) { result in
            if let dataArr = result.value as? [String:Any] {
                if let roomName = dataArr["room_name"] as? String {
                    let room = Room.init(id: result.key, name: roomName)
                    self.rooms.append(room)
                    self.roomsTableView.reloadData()
                }
            }
        }
    }
    
    func getUserNameById() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users/\(uid)/username").getData(completion: { error, result in
            if let error = error {
                self.displayError(errorText: error.localizedDescription)
            }
            let userName = result?.value as? String ?? ""
            self.userNameLB.text = "Hello \(userName)"
        })
    }
    
    func goToLoginScreen() {
        let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterVC
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        cell.roomNameLB.text = rooms[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
        vc.room = rooms[indexPath.row]
        vc.userName = userNameLB.text?.components(separatedBy: "Hello ").joined() ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
