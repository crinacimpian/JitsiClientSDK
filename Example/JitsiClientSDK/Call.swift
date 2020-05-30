//
//  Call.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

class Call {
    let uuid: UUID
    let isOutgoing: Bool
    var handle: String
    
    init(uuid: UUID, handle: String, isOutgoing: Bool = false) {
        self.uuid = uuid
        self.handle = handle
        self.isOutgoing = isOutgoing
        
    }
}
