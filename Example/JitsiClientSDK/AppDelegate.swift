//
//  AppDelegate.swift
//  JitsiClientSDK
//
//  Created by crinacimpian on 05/18/2020.
//  Copyright (c) 2020 crinacimpian. All rights reserved.
//


import UIKit
import PushKit
import JitsiMeet
import CallKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {

    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    let callManager = SpeakerboxCallManager()

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Finished launching with options: \(String(describing: launchOptions))")

        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]

        let localizedName = NSLocalizedString("Elyments", comment: "Elyments Jitsi Call")
        var iconTemplateImageData: Data? = nil
        if let iconMaskImage = UIImage(named: "IconMask") {
            iconTemplateImageData = iconMaskImage.pngData()
        }
        let ringtoneSound: String? = nil //"Ringtone.caf"
        JMCallKitProxy.configureProvider(localizedName: localizedName, ringtoneSound: ringtoneSound, iconTemplateImageData: iconTemplateImageData)
        JMCallKitProxy.addListener(callManager)
        JMCallKitProxy.enabled = true // is it needed?!
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let handle = url.startCallHandle else {
            print("Could not determine start call handle from URL: \(url)")
            return false
        }

        callManager.startCall(handle: handle)
        return true
    }

    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let handle = userActivity.startCallHandle else {
            print("Could not determine start call handle from user activity: \(userActivity)")
            return false
        }

        guard let video = userActivity.video else {
            print("Could not determine video from user activity: \(userActivity)")
            return false
        }

        callManager.startCall(handle: handle, video: video)
        return true
    }

    // MARK: PKPushRegistryDelegate

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("push registry called 1")
        /*
         Store push credentials on server for the active user.
         For sample app purposes, do nothing since everything is being done locally.
         */
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("push registry called 2")
        guard type == .voIP else { return }

        if let uuidString = payload.dictionaryPayload["UUID"] as? String,
            let handle = payload.dictionaryPayload["handle"] as? String,
            let hasVideo = payload.dictionaryPayload["hasVideo"] as? Bool,
            let uuid = UUID(uuidString: uuidString)
        {
            displayIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo)
        }
    }

    /// Display the incoming call to the user
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        print("displayIncomingCall \(uuid) \(handle) \(hasVideo)")

        // Display the incoming call
        let displayName = "jitsi hello" // temporary
        JMCallKitProxy.reportNewIncomingCall(UUID: uuid, handle: handle, displayName: displayName, hasVideo: hasVideo) { error in
            /*
                Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
                since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                let call = SpeakerboxCall(uuid: uuid)
                call.handle = handle

                self.callManager.addCall(call)
            }

            completion?(error as NSError?)
        }

    }

}

