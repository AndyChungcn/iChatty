//
//  MessageCell.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/7.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userAvatar: CircleImage!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        userAvatar.image = UIImage(named: message.userAvatar)
        userAvatar.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        usernameLabel.text = message.userName
        timeStampLabel.text = message.timeStamp
        messageBodyLabel.text = message.message
    }

}
