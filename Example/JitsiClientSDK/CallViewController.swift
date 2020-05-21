//
//  CallViewController.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JitsiMeet

class CallViewController: UIViewController, JitsiMeetViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cleanUp() {
        print("CallManager cleanUp")
        if(view != nil) {
            dismiss(animated: true, completion: nil)
            view = nil
        }
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        print("CallManager cleanUp 0")
        cleanUp()
    }
}

