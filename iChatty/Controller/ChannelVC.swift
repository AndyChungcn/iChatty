//
//  ChannelVC.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/5.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var avatarImageView: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @objc func userDataChange() {
        setupUserInfo()
    }
    
    @objc func channelsLoaded() {
        tableView.reloadData()
    }
    
    func setupUserInfo() {
        
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            avatarImageView.image = UIImage(named: UserDataService.instance.avatarName)
            avatarImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            avatarImageView.image = UIImage(named: "menuProfileIcon")
            avatarImageView.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func addChannelBtnTapped(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannelVC = AddChannelVC()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC, animated: true, completion: nil)
        }
    }        
}

extension ChannelVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CHANNEL_CELL, for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        print("Selected channel: \(channel)")
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController()?.revealToggle(animated: true)
    }
}
