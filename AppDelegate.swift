//
//  AppDelegate.swift
//  Game
//
//  Created by Appintosh 2.0  on 4/19/16.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        self.applicationDidTerminiate();
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.applicationDidTerminiate();
    }

    func applicationWillEnterForeground(application: UIApplication) {
        self.applicationDidTerminiate();
    }

    func applicationDidBecomeActive(application: UIApplication) {
        loadedBool=true;
    }

    func applicationWillTerminate(application: UIApplication) {
        self.applicationDidTerminiate();
    }
    
    func applicationDidTerminiate() {
        loadedBool=false;
    }

}
var loadedBool:Bool=false;

