//
//  LoginVC.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/5.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTextField.text, email != "" else { return }
        guard let password = passwordTextfield.text, password != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }

    func setupView() {
        spinner.isHidden = true
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
