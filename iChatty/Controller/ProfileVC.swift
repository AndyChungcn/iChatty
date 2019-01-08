//
//  ProfileVC.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/5.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var avatarImageView: CircleImage!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    @IBAction func logoutBtnTapped(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)        
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTap))
        bgView.addGestureRecognizer(tapGesture)
        
        usernameLabel.text = UserDataService.instance.name
        emailLabel.text = UserDataService.instance.email
        avatarImageView.image = UIImage(named: UserDataService.instance.avatarName)
        avatarImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    }
    
    @objc func closeTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
