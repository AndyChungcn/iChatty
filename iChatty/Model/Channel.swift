//
//  Channel.swift
//  iChatty
//
//  Created by 钟汇杭 on 2019/1/6.
//  Copyright © 2019 钟汇杭. All rights reserved.
//

import Foundation

struct Channel: Decodable {
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
}
