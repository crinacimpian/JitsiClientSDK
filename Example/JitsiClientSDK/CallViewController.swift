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
        print("CallManager:CVC conferenceTerminated")
        if (uuid != nil) {
            endCall(uuid: uuid!)
        }
        //cleanUp()
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

