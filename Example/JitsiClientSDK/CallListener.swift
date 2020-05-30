//
//  CallListener.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import AVKit
import CallKit
import JitsiMeet


final class CallListener: NSObject, JMCallKitListener {
    fileprivate let callManager: CallManager
    fileprivate let vc: CallViewController
    
    init(callManager: CallManager) {
        self.callManager = callManager
        self.vc = CallViewController()
    }
    
    // MARK: Listener Actions
    
    func performAnswerCall(UUID: UUID) {
        print("CM: performAnswerCall - \(UUID)")
        guard let call = callManager.callWithUUID(uuid: UUID) else {
            return
        }
        vc.join(call: call)
    }
    
    func performStartCall(UUID: UUID, isVideo: Bool) {
        print("CM: performStartCall")
        /* TODO - does JM takes care of the audio?!
         Configure the audio session, but do not start call audio here, since it must be done once the audio session has been activated by the system after having its priority elevated.
         */
        guard let call = callManager.callWithUUID(uuid: UUID) else {
            return
        }
        vc.join(call: call, video: isVideo)
        /*
         Set callback blocks for significant events in the call's lifecycle, so that the CXProvider may be updated to reflect the updated state.
         */
        JMCallKitProxy.reportOutgoingCall(with: UUID, startedConnectingAt: Date())
        JMCallKitProxy.reportOutgoingCall(with: UUID, connectedAt: Date())
    }
    
    func performEndCall(UUID: UUID) {
        print("CM: performEndCall - \(UUID)")
        vc.leave()
    }
    
    func providerDidReset() {
        print("CM: providerDidReset")
    }
    
    func performSetMutedCall(UUID: UUID, isMuted: Bool) {
        print("CM: performSetMutedCall \(isMuted)")
    }
    
    func providerDidActivateAudioSession(session: AVAudioSession) {
        print("CM: providerDidActivateAudioSession")
    }
    
    func providerDidDeactivateAudioSession(session: AVAudioSession) {
        print("CM: providerDidDeactivateAudioSession")
    }
    
    func providerTimedOutPerformingAction(action: CXAction) {
        print("CM: providerTimedOutPerformingAction")
    }
}
