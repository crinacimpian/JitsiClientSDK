//
//  ViewController.swift
//  JitsiClientSDK
//
//  Created by crinacimpian on 05/18/2020.
//  Copyright (c) 2020 crinacimpian. All rights reserved.
//

import UIKit
import JitsiMeet

class ViewController: UIViewController {
    
    @IBOutlet weak var videoButton: UIButton?
    
    @IBOutlet weak var roomName: UITextField!
    @IBOutlet weak var joinButton: UIButton?
    
    @IBOutlet weak var simulateIncomingCall: UIButton!
    @IBOutlet weak var simulateIncomingVideoCall: UIButton!
    
    var jitsiJoin: Bool = false
    static var jitsiServerUrl: URL = URL(fileURLWithPath: "https://meet.jit.si")
    //    static var jitsiServerUrl: URL = URL(fileURLWithPath: "https://meet.rajpratyush.com")
    
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var jitsiMeetView: JitsiMeetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func simulateIncomingCallPressed(_ sender: Any) {
        simulateIncomingCallInBG(sender, hasVideo: false)
    }
    
    @IBAction func simulateIncomingVideoCallPressed(_ sender: Any) {
        simulateIncomingCallInBG(sender, hasVideo: true)
    }
    
    
    @IBAction func openJitsiMeet(sender: Any?) {
        jitsiJoin = false
        cleanUp()
        
        // create and configure jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = true
            builder.serverURL = ViewController.jitsiServerUrl
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
            builder.setFeatureFlag("invite.enabled", withBoolean: false)
        }
        jitsiMeetView.join(options)
        
        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)
        
        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    
    @IBAction func openJitsiMeetJoin(sender: Any?) {
        jitsiJoin = true
        let room: String = roomName.text!
        if(room.count < 1) {
            return
        }
        
        // create and configure jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.room = room
            //            builder.serverURL = ViewController.jitsiServerUrl
        }
        
        // setup view controller
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        
        // join room and display jitsi-call
        jitsiMeetView.join(options)
        present(vc, animated: true, completion: nil)
        
    }
    
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        pipViewCoordinator?.resetBounds(bounds: rect)
    }
    
    fileprivate func simulateIncomingCallInBG(_ sender: Any, hasVideo: Bool) {
        /*
         Since the app may be suspended while waiting for the delayed action to begin,
         start a background task.
         */
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: "Jane", hasVideo: hasVideo) { _ in
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
    }
    
    fileprivate func cleanUp() {
        if jitsiJoin {
            if(jitsiMeetView != nil) {
                dismiss(animated: true, completion: nil)
                jitsiMeetView = nil
            }
        } else {
            jitsiMeetView?.removeFromSuperview()
            jitsiMeetView = nil
            pipViewCoordinator = nil
        }
    }
}

extension ViewController: JitsiMeetViewDelegate {
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        if jitsiJoin {
            cleanUp()
        } else {
            DispatchQueue.main.async {
                self.pipViewCoordinator?.hide() { _ in
                    self.cleanUp()
                }
            }
        }
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        if !jitsiJoin {
            DispatchQueue.main.async {
                self.pipViewCoordinator?.enterPictureInPicture()
            }
        }
    }
}

