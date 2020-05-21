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

    let callManager = CallManager()
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Finished launching with options: \(String(describing: launchOptions))")

        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]

        let localizedName = NSLocalizedString("Jitsi", comment: "Jitsi Call") // TODO
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
        return true
    }

    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
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
        JMCallKitProxy.reportNewIncomingCall(UUID: uuid, handle: handle, displayName: handle, hasVideo: true) { error in
            /*
                Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
                since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                print("no error")
            } else {
                print("error \(error.debugDescription)")
            }

            completion?(error as NSError?)
        }

    }

}

