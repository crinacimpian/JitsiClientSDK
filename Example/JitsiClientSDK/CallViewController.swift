//
//  CallViewController.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JitsiMeet

class CallViewController: UIViewController, JitsiMeetViewDelegate {
    fileprivate var jitsiMeetView: JitsiMeetView?
    var videoConfUrl: String = "https://meet.jit.si" //TODO
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CallViewController did load")
        
        jitsiMeetView = JitsiMeetView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        jitsiMeetView?.tag = 100 // TODO
        self.view.addSubview(jitsiMeetView!)
        
        jitsiMeetView!.delegate = self
        
        // create the request
        let jitsiUrl = URL(string: videoConfUrl)
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        
        // Set the options for the conference
        let conferenceOptions = JitsiMeetConferenceOptions.fromBuilder({ (builder) in
            builder.serverURL = jitsiUrl
            builder.room = "cc" //TODO
            builder.audioOnly = false
            builder.audioMuted = false
            builder.videoMuted = false
            builder.welcomePageEnabled = false
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
        })
        
        // Join the conference
        self.jitsiMeetView!.join(conferenceOptions)
        
    }
    
}
