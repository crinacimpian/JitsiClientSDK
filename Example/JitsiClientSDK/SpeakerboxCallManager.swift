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

final class SpeakerboxCallManager: NSObject, JMCallKitListener {

    var jitsiViewController: CallViewController?
    let callController = CXCallController()

    // JM Actions
    func performAnswerCall(UUID: UUID) {
        print("CallKit call is answered - \(UUID)")

        // Show the jitsi conference view.
//        jitsiViewController = CallViewController()
//        methodToShowTheViewController()
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
    // MARK: Actions

    func startCall(handle: String, video: Bool = false) {
        print("start call")
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)

        startCallAction.isVideo = video

        let transaction = CXTransaction()
        transaction.addAction(startCallAction)

        requestTransaction(transaction)
    }

    func end(call: SpeakerboxCall) {
        print("end call")
        let endCallAction = CXEndCallAction(call: call.uuid)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)

        requestTransaction(transaction)
    }

    func setHeld(call: SpeakerboxCall, onHold: Bool) {
        print("hold \(onHold)")
        let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
        let transaction = CXTransaction()
        transaction.addAction(setHeldCallAction)

        requestTransaction(transaction)
    }

    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }

    // MARK: Call Management

    static let CallsChangedNotification = Notification.Name("CallManagerCallsChangedNotification")

    private(set) var calls = [SpeakerboxCall]()

    func callWithUUID(uuid: UUID) -> SpeakerboxCall? {
        print("call with uuid \(uuid)")
        guard let index = calls.firstIndex(where: { $0.uuid == uuid }) else {
            return nil
        }
        return calls[index]
    }

    func addCall(_ call: SpeakerboxCall) {
        print("add call")
        calls.append(call)

        call.stateDidChange = { [weak self] in
            self?.postCallsChangedNotification()
        }

        postCallsChangedNotification()
    }

    func removeCall(_ call: SpeakerboxCall) {
        print("remove call")
        calls.removeFirst(where: { $0 === call })
        postCallsChangedNotification()
    }

    func removeAllCalls() {
        print("remove all calls")
        calls.removeAll()
        postCallsChangedNotification()
    }

    private func postCallsChangedNotification() {
        NotificationCenter.default.post(name: type(of: self).CallsChangedNotification, object: self)
    }

    // MARK: SpeakerboxCallDelegate

    func speakerboxCallDidChangeState(_ call: SpeakerboxCall) {
        print("call changed state")
        postCallsChangedNotification()
    }

}
