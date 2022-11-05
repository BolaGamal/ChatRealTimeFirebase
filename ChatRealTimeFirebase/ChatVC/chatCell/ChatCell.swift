//
//  ChatCell.swift
//  ChatRealTimeFirebase
//
//  Created by mac on 31/10/2022.
//

import UIKit

enum SenderType{
    case incoming
    case outgoing
}

class ChatCell: UITableViewCell {

    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var chatStack: UIStackView!
    
    
    func setupCell(message: Message) {
        nameLB.text = message.name
        chatText.text = message.text
    }
    
    func senderMessageType(_ senderType: SenderType){
        switch senderType {
        case .incoming:
            chatStack.alignment = .trailing
            textView.backgroundColor = #colorLiteral(red: 0.1227769628, green: 0.1739993095, blue: 0.1988108158, alpha: 1)
        case .outgoing:
            chatStack.alignment = .leading
            textView.backgroundColor = #colorLiteral(red: 0.002652069321, green: 0.3626890481, blue: 0.2993137836, alpha: 1)
        }
    }
    
    
}
