//
//  Parser.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/24.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit

class Parser: NSObject {

static func getRatingCount(with result:SearchResult?) -> String? {
    if let ratingCount = result?.userRatingCount {

        print("Rating count = \(ratingCount)")

        var ratingCountStr = ""
        if ratingCount < 1000 {
            ratingCountStr = String(ratingCount)
        } else if ratingCount < 10000 {
            ratingCountStr = String(format: "%.1f천", (Double(ratingCount) / 1000))
        } else if ratingCount < 100000 {
            ratingCountStr = String(format: "%.1f만", (Double(ratingCount) / 1000))
        }

        ratingCountStr = ratingCountStr.replacingOccurrences(of: ".0", with: "")
        return ratingCountStr
    }

    return nil
}

static func getUpdateDate(with result:SearchResult?) -> String? {
    if var lastlyUpdateDate = result?.currentVersionReleaseDate {
        lastlyUpdateDate = lastlyUpdateDate.replacingOccurrences(of: "T", with: " ")
        lastlyUpdateDate = lastlyUpdateDate.replacingOccurrences(of: "Z", with: "")

        let dateString:String = lastlyUpdateDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date:Date = dateFormatter.date(from: dateString)!
        var interval = Date().timeIntervalSince(date)/60/60/24

        if interval >= 7 {
            interval /= 7
            return String(Int(interval)) + "주전"
        } else {
            return String(Int(interval)) + "일전"
        }
    }

    return nil
}
}
