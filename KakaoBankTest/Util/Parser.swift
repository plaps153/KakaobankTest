//
//  Parser.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/24.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxSwift

class Parser: NSObject {
    
    static let `default` = Parser.init()
    
    private override init() {
        super.init()
    }
    
    var cachedResult:[String:SearchResult] = [:]
    
    func getRatingCount(with result:SearchResult?) -> String? {
        if let ratingCount = result?.userRatingCount {
                        
            var ratingCountStr = ""
            if ratingCount < 1000 {
                ratingCountStr = String(ratingCount)
            } else if ratingCount < 10000 {
                ratingCountStr = String(format: "%.1f천", (Double(ratingCount) / 1000))
            } else {
                ratingCountStr = String(format: "%.1f만", (Double(ratingCount) / 10000).rounded())
            }
            
            ratingCountStr = ratingCountStr.replacingOccurrences(of: ".0", with: "")
            return ratingCountStr
        }
        
        return nil
    }
    
    func getUpdateDate(with result:SearchResult?) -> String? {
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
    
    func getResultAsset(with results:[SearchResult]?) -> Observable<[SearchResult]> {
        
        guard let results = results else {
            return Observable.error(NSError.init(domain: "Failed to get asset", code: 0, userInfo: nil))
        }
        
        var assetResults = [SearchResult]()
        
        return Observable.create { (observer) -> Disposable in
            
            let success = {
                if assetResults.count == results.count {
                    observer.onNext(assetResults)
                    observer.onCompleted()
                    self.cachedResult.removeAll()
                } else if assetResults.count % 3 == 0 {
                    observer.onNext(assetResults)
                }
            }
            
            results.forEach({ [unowned self] (result) in

                if let trackCensoredName = result.trackCensoredName, self.cachedResult[trackCensoredName] != nil {
                    assetResults.append(self.cachedResult[trackCensoredName]!)
                    success()
                    return
                }
                
                DispatchQueue.global(qos: .userInteractive).sync {
                    
                    guard let artworkUrl = result.artworkUrl100,
                        let url = URL(string: artworkUrl),
                        let data = try? Data(contentsOf: url),
                        let artwork = UIImage(data: data) else {
                            observer.onError(NSError(domain: "Failed to get asset", code: 0, userInfo: nil))
                            return
                    }
                    
                    result.asset["artwork"] = artwork
                    
                    guard let screenshoturls = result.screenshotUrls else {
                        observer.onError(NSError(domain: "Failed to get asset", code: 0, userInfo: nil))
                        return
                    }
                    
                    for (i,_url) in screenshoturls.enumerated() {
                        
                        if i > 2 {
                            break
                        }
                        
                        DispatchQueue.global(qos: .userInteractive).sync {
                            guard let url = URL(string: _url),
                                let data = try? Data(contentsOf: url),
                                let screenshot = UIImage(data: data) else {
                                    return
                            }
                            
                            result.asset["screenshot\(i)"] = screenshot
                            
                            if i == 2 {
                                assetResults.append(result)
                                self.cachedResult[result.trackCensoredName!] = result
                                success()
                            }
                        }
                    }
                }
            })
            return Disposables.create()
        }
    }
}
