//
//  CallViewDelegate.swift
//  JitsiClientSDK_Example
//
//  Created by Crina Cimpian on 5/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import JitsiMeet

class CallViewDelegate: NSObject, JitsiMeetViewDelegate {
    static let instance = CallViewDelegate()
    
    // MARK: User's actions from the JitsiMeet View
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        print("CM: conferenceTerminated \(String(describing: data["url"])) and error \(String(describing: data["error"]))")

        // end the corresponding CXCall
        if let uuidPath  = URL(string: data["url"] as! String)?.path {
            let i = uuidPath.index(uuidPath.startIndex, offsetBy: 1) // skip "/"
            if let uuid = UUID(uuidString: String(uuidPath.suffix(from: i))) {
                print("CM: end call for \(uuid)")
                AppDelegate.shared.callManager.endCall(uuid: uuid)
            }
        }
        // TODO
        //        let error  = data["error"] as! String
        //          map error codes at https://github.com/jitsi/lib-jitsi-meet/blob/master/JitsiConnectionErrors.js
        //          with CXCallEndedReason
        //        JMCallKitProxy.reportCall(with: UUID, endedAt: Date(), reason: CXCallEndedReason.declinedElsewhere)
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("CM: conferenceJoined \(String(describing: data["url"]))")
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        print("CM: conferenceWillJoin \(String(describing: data["url"]))")
    }
}
