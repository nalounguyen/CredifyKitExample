//
//  AppDelegate.swift
//  ExampleApp
//
//  Created by Nalou Nguyen on 15/03/2021.
//

import UIKit
import CredifyKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        
//      bluecare:  1OBcFdehn2msfHApX7hnzp8GYBDaKJRAVrKtonvvCHrvkxRB4Z2BgwM0OoKXAnvu
        let config = CredifyConfiguration(apiKey: "WaXSjOqK0JqSOH1VJ6Op1kkQTdPAhffv5bflck7SzwRjCK0MqUmjSHyvfAan3djf",
                                          environment: .DEV,
                                          userRegistrationApi: "https://dev-demo-api.credify.one/sendo/create")
        CredifyKitSDK.shared.config(with: config)
        
        return true
    }
}

