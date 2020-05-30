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

class CallViewController: UIViewController {
    fileprivate var jitsiMeetView: JitsiMeetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func join(call: Call, video: Bool = true) {
        print("CM: join")
        // create and configure jitsimeet view
        jitsiMeetView = JitsiMeetView() // TODO when join() called multiple times
        jitsiMeetView?.delegate = CallViewDelegate.instance
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.setFeatureFlag("chat.enabled", withBoolean: false)

            builder.room = call.uuid.uuidString
            builder.subject = call.handle
            builder.videoMuted = !video
        }

        // setup view controller
        self.modalPresentationStyle = .fullScreen
        self.view = jitsiMeetView

        jitsiMeetView?.join(options)
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }

    func leave() {
        print("CM: leave")
        jitsiMeetView?.leave()
        if(view != nil) {
            print("CM: leave view \(String(describing: view))")
            view = nil
        }
        dismiss(animated: true, completion: nil)
    }
}
