//
//  MessageServicer.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/6.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    let defaults = UserDefaults.standard
    
    var channels: [Channel] = []
    var selectedChannel: Channel?
    var unreadChannels: [String] = []
    var messages: [Message] = []
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data).array
                    for item in json! {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    func findAllMessages(channelId: String ,completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                self.removeAllMessages()
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data).array
                    for item in json! {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func removeAllMessages() {
        messages.removeAll()
    }
    
    func removeAllChannels() {
        channels.removeAll()
    }
    
}
