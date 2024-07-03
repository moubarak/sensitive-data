//
//  AppDelegate.swift
//  Sensitive Data
//
//  Created by Mohamed Moubarak on 5/31/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("applicationDidEnterBackground")
        // backgroundWindow.isHidden = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NSLog("applicationWillEnterForeground")
        // backgroundWindow.isHidden = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        UIGraphicsEndImageContext()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 101
        blurEffectView.frame = (self.window?.rootViewController?.view.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }?.addSubview(blurEffectView)
        NSLog("applicationWillResignActive")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("applicationDidBecomeActive")
        let viewWithTag : UIView? = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }?.subviews.last?.viewWithTag(101) as? UIView
        if let view = viewWithTag {
            view.removeFromSuperview()
        }
    }
}

extension UIView {
    func capture() -> UIImage? {
        var image: UIImage?

        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = isOpaque
            let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
            image = renderer.image { context in
                drawHierarchy(in: frame, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
            drawHierarchy(in: frame, afterScreenUpdates: true)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        return image
    }
}
