//
//  ChatVC.swift
//  ChatRealTimeFirebase
//
//  Created by mac on 31/10/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ChatVC: UIViewController {
    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var room: Room?
    var messages = [Message]()
    var userName = ""
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeMessages()
    }
    
    func setupViews() {
        if let roomName = room?.name { title = roomName }
        chatTableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let message = messageTF.text, !message.isEmpty else { return }
        sendMessage(text: message)
    }
    
    func sendMessage(text: String) {
        if let roomId = room?.id, let uid = Auth.auth().currentUser?.uid {
            let dataArr: [String:Any] = ["sender_name":userName, "text": text, "user_id": uid]
            ref.child("rooms").child(roomId).child("messages").childByAutoId().setValue(dataArr) { error, data in
                if let error = error {
                    self.displayError(errorText: error.localizedDescription)
                }else {
                    self.messageTF.text = ""
                    print("message sent succesfully")
                }
            }
        }
    }
    
    func observeMessages() {
        if let roomId = room?.id {
            ref.child("rooms").child(roomId).child("messages").observe(.childAdded) { DataSnapshot in
                if let dataArr = DataSnapshot.value as? [String:Any] {
                    guard let senderName = dataArr["sender_name"] as? String,
                          let messageText = dataArr["text"] as? String,
                          let userId = dataArr["user_id"] as? String else { return }
                    let message = Message.init(id: DataSnapshot.key, name: senderName, text: messageText, user_id: userId)
                    self.messages.append(message)
                    self.chatTableView.reloadData()
                }
            }
        }
    }
    
    
}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.setupCell(message: messages[indexPath.row])
        if let uid = Auth.auth().currentUser?.uid {
            if messages[indexPath.row].user_id == uid {
                cell.senderMessageType(.outgoing)
            }else {
                cell.senderMessageType(.incoming)
            }
        }
        return cell
    }
    
    
}
