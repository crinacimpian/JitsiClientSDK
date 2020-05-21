/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Manager of SpeakerboxCalls, which demonstrates using a CallKit CXCallController to request actions on calls
    Maintains a list of calls
*/

import UIKit
import CallKit
import JitsiMeet
import AVKit

final class CallManager: NSObject, JMCallKitListener {

    var jitsiViewController: CallViewController?
    let callController = CXCallController()

    // MARK: Actions

    func performAnswerCall(UUID: UUID) {
        print("CallKit call is answered - \(UUID)")

        // Show the jitsi conference view - how?!
        jitsiViewController = CallViewController()
        //methodToShowTheViewController()
    }

    func methodToShowTheViewController() {
        //jitsiViewController?.show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
        jitsiViewController?.view.viewWithTag(100)?.isHidden = false
    }

    func providerDidReset() {
        print("provider did reset")
    }

    func performEndCall(UUID: UUID) {
        print("CallKit call ended - \(UUID)")
    }

    func performSetMutedCall(UUID: UUID, isMuted: Bool) {
        print("call muted \(isMuted)")
    }

    func performStartCall(UUID: UUID, isVideo: Bool) {
        print("performStartCall")
    }

    func providerDidActivateAudioSession(session: AVAudioSession) {
        print("didActivateAudioSession")
    }

    func providerDidDeactivateAudioSession(session: AVAudioSession) {
        print("didDeactivateAudioSession")
    }

    func providerTimedOutPerformingAction(action: CXAction) {
        print("timedOut")
    }

}
