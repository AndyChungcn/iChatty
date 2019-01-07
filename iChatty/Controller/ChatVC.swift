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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        print("=======")
        print(UserDataService.instance.avatarName)
        print(UserDataService.instance.email)
        print("=======")
        
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
    }
    
    
    @objc func userDataDidChange() {
        if AuthService.instance.isLoggedIn {
            onLoginGetChannels()
        } else {
            channelNameLabel.text = "Please Login"
        }
    }
    
    @objc func channelSelected() {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = channelName
    }
    
    func onLoginGetChannels() {
        MessageService.instance.findAllChannel { (success) in
            if success {}
        }
    }
}
