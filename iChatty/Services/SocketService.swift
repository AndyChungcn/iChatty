//
//  SocketService.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/6.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)            
            MessageService.instance.channels.append(newChannel)
            print("all the channels after append new channel: \(MessageService.instance.channels)")
            completion(true)
        }
    }
    
}
