//
//  ServerTimeHelper.swift
//  travelApp
//
//  Created by Fedor Korshikov on 07.12.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation

class LastSyncTimeHelper {
    public static func getLastSyncTime() -> String {
        if let servTime = UserDefaults.standard.string(forKey: "lastSyncTime") {
            return servTime
        } else {
            return "0"
        }
    }

    public static func setLastSyncTime(time: String){
        UserDefaults.standard.setValue(time, forKey: "lastSyncTime")
    }

    public static func clearLastSyncTime(){
        UserDefaults.standard.removeObject(forKey: "lastSyncTime")
    }

}
