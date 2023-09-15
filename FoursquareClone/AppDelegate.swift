//
//  AppDelegate.swift
//  FoursquareClone
//
//  Created by Atil Samancioglu on 9.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

// parse entegrasyonunu burada başlatıyoruz.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { // burada bir ParseConfiguration dosyası oluşturucaz
        
        let configuration = ParseClientConfiguration { (ParseMutableClientConfiguration) in // parse ın değiştirilebilir bir client ayarını yapabileceğimiz bir blok veriyor bu fonksiyon (ParseMutableClientConfiguration)
            ParseMutableClientConfiguration.applicationId = "OavOOOWrDD1BaRriQxlTNH5MXnDmKROmxs8ffof4" // sunucuya bağlanabilmek için bu üç şeye ihtiyaç var. string içindeki verileri parse ın sitesinden proje oluşturduktan sonra server settings-core settings ten alıyoruz
            ParseMutableClientConfiguration.clientKey = "04er0MRECvd4sGPYEubLCBBYcbzTdWUTiSQg1OG6"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            
        }
        
        Parse.initialize(with: configuration)
        
        
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

