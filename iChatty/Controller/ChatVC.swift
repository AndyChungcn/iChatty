//
//  ChatVC.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/5.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUserLabel: UILabel!    
    
    // Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindtoKeyboard()        
        messageTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)

        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    print("Successfully found the user: \(UserDataService.instance.name)")
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        }
        
        SocketService.instance.getMessage { (newMessage) in
            
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0

            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    print("typingUser: \(typingUser)")
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }

            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUserLabel.text = "\(names) \(verb) typing"
            } else {
                self.typingUserLabel.text = ""
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        if messageTextField.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextField.text, message != "" else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                }
            }
        }
    }
    
    @objc func userDataDidChange() {
        if AuthService.instance.isLoggedIn {
            onLoginGetChannels()
        } else {
            channelNameLabel.text = "Please Login"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected() {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = channelName
        sendBtn.isHidden = true
        getMessages()
    }
    
    func onLoginGetChannels() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channel yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessages(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - UITableView Protocol
extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_CELL, for: indexPath) as? MessageCell {
            if MessageService.instance.messages.count > 0 {
                cell.configureCell(message: MessageService.instance.messages[indexPath.row])
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
