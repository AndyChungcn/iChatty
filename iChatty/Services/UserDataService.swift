//
//  UserDataService.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/5.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    let defaults = UserDefaults.standard
    
    public private(set) var id = ""
    public private(set) var avatarColor: String {
        get {            
            return defaults.value(forKey: AVATAR_COLOR) as? String ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: AVATAR_COLOR)
        }
    }
    public private(set) var avatarName: String {
        get {
            return (defaults.value(forKey: AVATAR_NAME) as? String) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: AVATAR_NAME)
        }
    }
    public private(set) var email: String {
        get {
            return (defaults.value(forKey: USER_EMAIL) as? String) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: USER_EMAIL)
        }
    }
    public private(set) var name: String {
        get {
            return defaults.value(forKey: USER_NAME) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: USER_NAME)
        }
    }
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
    }
    
    func logoutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
    }
    
}
