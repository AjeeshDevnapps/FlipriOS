//
//  AppReview.swift
//  LocasunVP
//
//  Created by Benjamin McMurrich on 13/09/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import Foundation
import StoreKit
import MessageUI

let kAppRequestReviewGuardKey = "AppRequestReviewGuard"
let kAppRunLogKey = "AppRunLog"

class AppReview: NSObject, MFMailComposeViewControllerDelegate {
    
    var usesUntilPrompt = 4
    var consecutiveDaysForCountingUses = 15 //During the last 15 days... 0, means all uses count
    var daysUntilPrompt = 3
    var daysBeforeNewRequestWhenDeclined = 21
    var daysBeforeNewRequestWhenReviewed = 180
    
    // Pour les tests
    /*
    var usesUntilPrompt = 1
    var consecutiveDaysForCountingUses = 7 //During the last 7 days... 0, means all uses count
    var daysUntilPrompt = 0
    var daysBeforeNewRequestWhenDeclined = 0
    var daysBeforeNewRequestWhenReviewed = 0
    */
    
    var appID:String?
    var feedbackEmails = [String]()
    
    static let shared : AppReview = {
        let instance = AppReview()
        return instance
    }()
    
    var topViewController:UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    func activate(appID:String, feedbackEmails:[String]) {
        self.appID = appID
        self.feedbackEmails = feedbackEmails
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActiveCallBack(_:)), name:UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActiveCallBack(_ notification: Notification) {
        let defaults = UserDefaults.standard
        if let runLog = defaults.value(forKey: kAppRunLogKey) as? [Date] {
            if let lastRun = runLog.first {
                print("lastRun.timeIntervalSinceNow: \(lastRun.timeIntervalSinceNow)")
                if lastRun.timeIntervalSinceNow < -120 {
                    var newLog = [Date()]
                    newLog += runLog
                    defaults.setValue(newLog, forKey: kAppRunLogKey)
                }
            }
        } else {
            defaults.setValue([Date()], forKey: kAppRunLogKey)
        }
        
    }
    
    func requestReviewIfNeeded() {
        
        let defaults = UserDefaults.standard
        
        if let runLog = defaults.value(forKey: kAppRunLogKey) as? [Date] {
            
            if daysUntilPrompt > 0 {
                if let firstRun = runLog.last {
                    if firstRun.timeIntervalSinceNow > -1 * Double(daysUntilPrompt) * 3600 * 24 {
                        return
                    }
                }
            }
            
            var runCount = 0
            for run in runLog {
                if consecutiveDaysForCountingUses > 0 {
                    if run.timeIntervalSinceNow > -1 * Double(consecutiveDaysForCountingUses) * 3600 * 24 { //During the last 7 days...
                        runCount = runCount + 1
                    }
                } else {
                    runCount = runCount + 1
                }
            }
            if runCount >= usesUntilPrompt {
                requestReview()
            }
        }
    }
    
    func requestReview() {
        
        let defaults = UserDefaults.standard
        
        if let guardDate = defaults.value(forKey: kAppRequestReviewGuardKey) as? Date {
            print("guardDate.timeIntervalSinceNow: \(guardDate.timeIntervalSinceNow)")
            if guardDate.timeIntervalSinceNow > 0 {
                return
            }
        }
        
        presentFirstQuestion()
    }
    
    func presentFirstQuestion() {
        
        //let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let alert = UIAlertController(title: "Enjoying this app?".localized, message:nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Yes!".localized, style: .cancel, handler: { (action) in
            let windowCount = UIApplication.shared.windows.count
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if windowCount < UIApplication.shared.windows.count {
                        // assume review popup showed instead of some other system alert
                    } else {
                        self.presentLoverQuestion()
                    }
                }
            } else {
                self.presentLoverQuestion()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Not really".localized, style: .default, handler: { (action) in
            self.presentHaterQuestion()
        }))
        topViewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentHaterQuestion() {
        let alert = UIAlertController(title: "Would you mind giving us some feedback?".localized, message:nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok, sure".localized, style: .cancel, handler: { (action) in
            self.presentFeedbackMailComposer()
            var dateComponent = DateComponents()
            dateComponent.day = self.daysBeforeNewRequestWhenReviewed
            UserDefaults.standard.setValue(Calendar.current.date(byAdding: dateComponent, to: Date()), forKey: kAppRequestReviewGuardKey)
        }))
        alert.addAction(UIAlertAction(title: "Later".localized, style: .default, handler: { (action) in
            var dateComponent = DateComponents()
            dateComponent.day = self.daysBeforeNewRequestWhenDeclined
            UserDefaults.standard.setValue(Calendar.current.date(byAdding: dateComponent, to: Date()), forKey: kAppRequestReviewGuardKey)
        }))
        topViewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentLoverQuestion() {
        presentLoverQuestion(withTitle: "How about a rating on the App Store, then?".localized, message: nil)
    }
    
    func presentLoverQuestion(withTitle title:String?, message:String?) {
        
        let defaults = UserDefaults.standard
        
        if let guardDate = defaults.value(forKey: kAppRequestReviewGuardKey) as? Date {
            print("guardDate.timeIntervalSinceNow: \(guardDate.timeIntervalSinceNow)")
            if guardDate.timeIntervalSinceNow > 0 {
                return
            }
        }
        
        let alert = UIAlertController(title: title, message:message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok, sure".localized, style: .cancel, handler: { (action) in
            self.presentStoreReviewController()
            var dateComponent = DateComponents()
            dateComponent.day = self.daysBeforeNewRequestWhenReviewed
            UserDefaults.standard.setValue(Calendar.current.date(byAdding: dateComponent, to: Date()), forKey: kAppRequestReviewGuardKey)
        }))
        alert.addAction(UIAlertAction(title: "Later".localized, style: .default, handler: { (action) in
            var dateComponent = DateComponents()
            dateComponent.day = self.daysBeforeNewRequestWhenDeclined
            UserDefaults.standard.setValue(Calendar.current.date(byAdding: dateComponent, to: Date()), forKey: kAppRequestReviewGuardKey)
        }))
        topViewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentStoreReviewController() {
        let windowCount = UIApplication.shared.windows.count
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if windowCount < UIApplication.shared.windows.count {
                    // assume review popup showed instead of some other system alert
                } else {
                    if let appID = AppReview.shared.appID {
                        if let reviewUrl = URL(string: "https://itunes.apple.com/app/id\(appID)?action=write-review") {
                            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
                        }
                    } else {
                        print("Could not request for review, no app ID is set.")
                    }
                }
            }
        } else {
            if let appID = AppReview.shared.appID {
                if let reviewUrl = URL(string: "https://itunes.apple.com/app/id\(appID)?action=write-review") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(reviewUrl)
                    }
                }
            } else {
                print("Could not request for review, no app ID is set.")
            }
        }
        
        
    }
    
    func presentFeedbackMailComposer() {
        if feedbackEmails.count > 0 {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(feedbackEmails)
                let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                mail.setSubject("\(appName) iOS Feedback")
                
                let device = UIDevice.current.type.rawValue
                let osVersion = UIDevice.current.systemVersion
                let appVersion = "\(Bundle.main.releaseVersionNumber!) (\(Bundle.main.buildVersionNumber!))"
                
                mail.setMessageBody("<br><br><br><br><i><font color=\"LightGrey\">My device is an \(device) with iOS \("\(osVersion)") and the app version is \(appVersion).</font></i>", isHTML: true)
                //mail.setMessageBody("<br><br><br><br><i><font color=\"LightGrey\">J'utilise un \(device) avec iOS \("\(osVersion)") et la version de l'app est \(appVersion).</font></i>", isHTML: true)
                
                topViewController?.present(mail, animated: true)
            } else {
                print("Could not send mail.")
            }
        } else {
            print("App review Error : No feedback email are set.")
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            topViewController?.showSuccess(title: "Thanks!".localized, message: "Your message has been sent.")
        } else if let error = error {
            topViewController?.showError(title: "Error".localized, message: error.localizedDescription)
        }
    }
}
/*
public enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro10_5      = "iPad Pro 10.5\"",
    iPadPro10_5_cell = "iPad Pro 10.5\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8plus      = "iPhone 8 Plus",
    iPhoneX          = "iPhone X",
    unrecognized     = "?unrecognized?"
}

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"       : .simulator,
            "x86_64"     : .simulator,
            "iPod1,1"    : .iPod1,
            "iPod2,1"    : .iPod2,
            "iPod3,1"    : .iPod3,
            "iPod4,1"    : .iPod4,
            "iPod5,1"    : .iPod5,
            "iPad2,1"    : .iPad2,
            "iPad2,2"    : .iPad2,
            "iPad2,3"    : .iPad2,
            "iPad2,4"    : .iPad2,
            "iPad2,5"    : .iPadMini1,
            "iPad2,6"    : .iPadMini1,
            "iPad2,7"    : .iPadMini1,
            "iPhone3,1"  : .iPhone4,
            "iPhone3,2"  : .iPhone4,
            "iPhone3,3"  : .iPhone4,
            "iPhone4,1"  : .iPhone4S,
            "iPhone5,1"  : .iPhone5,
            "iPhone5,2"  : .iPhone5,
            "iPhone5,3"  : .iPhone5C,
            "iPhone5,4"  : .iPhone5C,
            "iPad3,1"    : .iPad3,
            "iPad3,2"    : .iPad3,
            "iPad3,3"    : .iPad3,
            "iPad3,4"    : .iPad4,
            "iPad3,5"    : .iPad4,
            "iPad3,6"    : .iPad4,
            "iPhone6,1"  : .iPhone5S,
            "iPhone6,2"  : .iPhone5S,
            "iPad4,1"    : .iPadAir1,
            "iPad4,2"    : .iPadAir2,
            "iPad4,4"    : .iPadMini2,
            "iPad4,5"    : .iPadMini2,
            "iPad4,6"    : .iPadMini2,
            "iPad4,7"    : .iPadMini3,
            "iPad4,8"    : .iPadMini3,
            "iPad4,9"    : .iPadMini3,
            "iPad6,3"    : .iPadPro9_7,
            "iPad6,11"   : .iPadPro9_7,
            "iPad6,4"    : .iPadPro9_7_cell,
            "iPad6,12"   : .iPadPro9_7_cell,
            "iPad6,7"    : .iPadPro12_9,
            "iPad6,8"    : .iPadPro12_9_cell,
            "iPad7,3"    : .iPadPro10_5,
            "iPad7,4"    : .iPadPro10_5_cell,
            "iPhone7,1"  : .iPhone6plus,
            "iPhone7,2"  : .iPhone6,
            "iPhone8,1"  : .iPhone6S,
            "iPhone8,2"  : .iPhone6Splus,
            "iPhone8,4"  : .iPhoneSE,
            "iPhone9,1"  : .iPhone7,
            "iPhone9,2"  : .iPhone7plus,
            "iPhone9,3"  : .iPhone7,
            "iPhone9,4"  : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}
*/
