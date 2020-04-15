//
//  Trip.swift
//  travelApp
//
//  Created by Fedor Korshikov on 28.02.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Trip {
    internal init(Id: String, Name: String, TextField: String, PlaceIds: [String], goodIds: [String], goalIds: [String], timeFrom: Int64, timeTo: Int64) {
        self.Id = Id
        self.Name = Name
        self.TextField = TextField
        self.PlaceIds = PlaceIds
        self.goodIds = goodIds
        self.goalIds = goalIds
        if (timeFrom > 0){
            self.dateFrom = Date(ticks: timeFrom)
        }
        if (timeTo > 0) {
            self.dateTo = Date(ticks: timeTo)
        }
    }
    var Id : String
    var Name : String
    var TextField : String
    var PlaceIds: [String]
    var dateFrom: Date?
    var dateTo: Date?
    var goodIds: [String]
    var goalIds: [String]
    
    func getDateStringFromTo() -> String {
        
        let dateFormatterWoYear = DateFormatter()
        dateFormatterWoYear.dateFormat = "dd, MMM"
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.dateFormat = " YYYY"
        var strDateFrom = String()
        var strDateTo = String()
        
        if let dateFrom = dateFrom {
            strDateFrom += dateFormatterWoYear.string(from: dateFrom)
        } else {
            strDateFrom += "..."
        }
        
        if let dateTo = dateTo {
            strDateTo += dateFormatterWoYear.string(from: dateTo)
        } else {
            strDateTo += "..."
        }
        
        
        
        labelpoint: if let dateFrom = dateFrom, let dateTo = dateTo {
            let calendar = Calendar.current
            guard let year1 = calendar.dateComponents([.year], from: dateFrom).year, let year2 = calendar.dateComponents([.year], from: dateTo).year else { break labelpoint}
            if year1 != year2 {
                strDateFrom += dateFormatterYear.string(from: dateFrom)
                strDateTo += dateFormatterYear.string(from: dateTo)
            }
        }
        
        return strDateFrom + " -> " + strDateTo
    }
    
}

extension Date {
    // create date from c# 18digit format
    init(ticks: Int64) {
        self.init(timeIntervalSince1970: Double(ticks)/10_000_000 - 62_135_596_800)
    }
    // get c# 18digits format from date
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
