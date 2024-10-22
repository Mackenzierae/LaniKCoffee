//
//  AppDelegate.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/3/23.
//

import FirebaseCore
import FirebaseFirestore
import GooglePlaces
import GoogleMaps
import UIKit

@main


class AppDelegate: UIResponder, UIApplicationDelegate {
    let googleApiKey = "AIzaSyC2Gz6GYazLoW86AEB_5xVv1arbtE-6rts"

//    var window: UIWindow?  // from Firebase initialization code
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let db = Firestore.firestore()
        print("DBBBBB", db)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

