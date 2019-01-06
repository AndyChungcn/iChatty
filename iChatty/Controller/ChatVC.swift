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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        print("=======")
        print(UserDataService.instance.avatarName)
        print(UserDataService.instance.email)
        print("=======")
        
        if AuthService.instance.isLoggedIn && UserDataService.instance.email == "" {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        }
        
        if MessageService.instance.channels.isEmpty {
            MessageService.instance.findAllChannel { (success) in
                if success {
                    print("got all data")
                }
            }
        }
        
    }
}
