//
//  CallViewController.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import CallKit
import JitsiMeet

class CallViewController: UIViewController, JitsiMeetViewDelegate {
    var uuid:UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("CallManager:CVC viewDidDisappear")
    }
    func cleanUp() {
        print("CallManager:CVC cleanUp")
        if(view != nil) {
            print("CallManager:CVC cleanUp \(String(describing: view))")
            view = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        print("CallManager:CVC conferenceTerminated \(String(describing: data["url"]))")
        // TODO - better way to extract the UUID from URL
        if let uuidPath  = URL(string: data["url"] as! String)?.path {
            let i = uuidPath.index(uuidPath.startIndex, offsetBy: 1) // skip "/"
            if let uuid = UUID(uuidString: String(uuidPath.suffix(from: i))) {
                print("CallManager:CVC end call for \(uuid)")
                endCall(uuid: uuid)
            }
        }
        //cleanUp()
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("CallManager:CVC conferenceJoined \(String(describing: data))")
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        print("CallManager:CVC conferenceWillJoin \(String(describing: data))")
    }
    func endCall(uuid:UUID) { // TODO - pass Call
        print("CallManager end call")
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)
        JMCallKitProxy.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
}

