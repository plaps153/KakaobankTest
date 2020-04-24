//
//  ViewModel.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/23.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewModel: NSObject {

    let searchedTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")

    lazy var data: Driver<[String]> = {
        return self.searchedTextRelay
            .asObservable()
            .debug()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest(self.getSearchedText(_:))
            .asDriver(onErrorJustReturn: [])
    }()

    let localStorageKey = "SearchResultKey"

    func setSearchedText(with text: String) {
        if let data = UserDefaults.standard.object(forKey: localStorageKey) as? Data,
            var textArr = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] {
            if textArr.count == 0 || textArr.contains(text) == false {
                textArr.append(text)

                guard let textData = try? NSKeyedArchiver.archivedData(withRootObject: textArr, requiringSecureCoding: false) else { return }
                UserDefaults.standard.set(textData, forKey: localStorageKey)
            }
        } else {
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: [text], requiringSecureCoding: false) else { return }
            UserDefaults.standard.set(data, forKey: localStorageKey)
        }
    }

    func getSearchedText(_ text:String) -> Observable<[String]> {
        guard let data = UserDefaults.standard.value(forKey: localStorageKey) as? Data,
            let textArr = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] else {
                return Observable.just([])
        }

        if text.count == 0 {
            return Observable.from(optional: textArr)
        }

        return Observable.from(optional: textArr.filter { $0.contains(text) })
    }
    
}
