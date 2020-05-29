//
//  CallViewController.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import CallKit
import JitsiMeet
import AVKit

final class CallManager: NSObject, JMCallKitListener {
    
    let vc = CallViewController()
    var jitsiMeetView: JitsiMeetView?
    
    func startCall(handle: String, video: Bool = true) {
        print("CallManager start call")
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)

        startCallAction.isVideo = video

        let transaction = CXTransaction()
        transaction.addAction(startCallAction)
        JMCallKitProxy.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }

    // MARK: Actions
    
    func performAnswerCall(UUID: UUID) {
        print("CallManager call is answered - \(UUID)")
        jitsiMeetJoin(UUID: UUID)
    }
    
    func performEndCall(UUID: UUID) {
        print("CallManager call ended - \(UUID)")
        jitsiMeetEnd(UUID: UUID)
        // TODO - call following wherever it is needed for each end reason
//        JMCallKitProxy.reportCall(with: UUID, endedAt: Date(), reason: CXCallEndedReason.declinedElsewhere)
    }
    
    fileprivate func jitsiMeetJoin(UUID: UUID, video: Bool = true) {
        // create and configure jitsimeet view
        jitsiMeetView = JitsiMeetView()
        jitsiMeetView?.delegate = vc
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
            builder.setFeatureFlag("invite.enabled", withBoolean: false)
            
            // TODO get the following info based on UUID
            builder.room = UUID.uuidString
            builder.subject = "Subject"
            builder.audioOnly = false
            builder.audioMuted = false
            builder.videoMuted = !video
        }
        
        // setup view controller
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        vc.uuid = UUID
        
        // join room and display jitsi-call
        jitsiMeetView?.join(options)
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func jitsiMeetEnd(UUID: UUID) {
        print("CallManager jitsiMeetEnd")
        vc.cleanUp()
    }
    func providerDidReset() {
        print("CallManager provider did reset")
    }
    
    func performSetMutedCall(UUID: UUID, isMuted: Bool) {
        print("CallManager call muted \(isMuted)")
    }
    
    
    func performStartCall(UUID: UUID, isVideo: Bool) {
        print("CallManager performStartCall")
        /* TODO - does JM takes care of the audio?!
            Configure the audio session, but do not start call audio here, since it must be done once the audio session has been activated by the system after having its priority elevated.
         */
        jitsiMeetJoin(UUID: UUID, video: isVideo)
        /*
            Set callback blocks for significant events in the call's lifecycle, so that the CXProvider may be updated to reflect the updated state.
         */
        JMCallKitProxy.reportOutgoingCall(with: UUID, startedConnectingAt: Date())
        JMCallKitProxy.reportOutgoingCall(with: UUID, connectedAt: Date())
    }
    
    func providerDidActivateAudioSession(session: AVAudioSession) {
        print("CallManager didActivateAudioSession")
    }
    
    func providerDidDeactivateAudioSession(session: AVAudioSession) {
        print("CallManager didDeactivateAudioSession")
    }
    
    func providerTimedOutPerformingAction(action: CXAction) {
        print("CallManager timedOut")
    }
    
}
