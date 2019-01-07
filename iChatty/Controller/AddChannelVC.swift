//
//  AddChannelVC.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/6.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTap))
        bgView.addGestureRecognizer(closeTapGesture)
        
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTap))
        cardView.addGestureRecognizer(cardTapGesture)
        
        nameLabel.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceholder])
        descriptionLabel.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceholder])
    }
    
    @objc func cardTap() {
        view.endEditing(true)
    }
    
    @objc func closeTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelBtnTapped(_ sender: Any) {
        guard let channelName = nameLabel.text, channelName != "" else { return }
        guard let channelDesc = descriptionLabel.text, channelDesc != "" else { return }        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success {
                print("add channel success!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
