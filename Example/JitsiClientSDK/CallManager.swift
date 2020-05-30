//
//  CallViewController.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CallKit
import JitsiMeet

final class CallManager {
    // MARK: Call Actions
    func startCall(handle: String, video: Bool = true) {
        print("CM:  startCall")
        let uuid = UUID()
        addCall(Call(uuid: uuid, handle: handle))
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        
        startCallAction.isVideo = video
        
        let transaction = CXTransaction()
        transaction.addAction(startCallAction)
        JMCallKitProxy.request(transaction) { error in
            if let error = error {
                print("CM: Error requesting transaction: \(error)")
                // TODO report end call to provider
            } else {
                print("CM: Requested transaction successfully")
            }
        }
    }
    
    func endCall(uuid:UUID) { // TODO - pass Call
        print("CM: endCall")
        removeCall(uuid: uuid)
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)
        JMCallKitProxy.request(transaction) { error in
            if let error = error {
                print("CM: Error requesting transaction: \(error)")
                // TODO report ?!
            } else {
                print("CM: Requested transaction successfully")
            }
        }
    }
    
    // MARK: Call List Management
    
    static let CallsChangedNotification = Notification.Name("CallManagerCallsChangedNotification")

    private(set) var calls = [Call]()

    func callWithUUID(uuid: UUID) -> Call? {
        print("CM: callWithUUID - \(uuid)")
        guard let index = calls.firstIndex(where: { $0.uuid == uuid }) else {
            return nil
        }
        return calls[index]
    }

    func addCall(_ call: Call) {
        print("CM: addCall")
        calls.append(call)
    }
    
    func removeCall(uuid: UUID) {
        print("CM: removeCall")
        guard let index = calls.firstIndex(where: { $0.uuid == uuid }) else {
            return
        }
        calls.remove(at: index)
    }
}
