//
//  RatingStackView.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/24.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit

class RatingStackView: UIStackView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func rating(with result:SearchResult?) {

        guard self.arrangedSubviews.count == 5 else {
            return
        }

        guard let result = result else { return }

        // Initialization
        self.arrangedSubviews.forEach {
            if let iv = $0 as? UIImageView {
                iv.image = UIImage(systemName: "star")
            }
        }

        guard let ratingCount = result.averageUserRating, ratingCount > 0 else { return }

        let integerRatingCount = Int(ratingCount)
        let floatingRatingCount = ratingCount - Double(integerRatingCount)

        (0...integerRatingCount - 1).forEach { (idx) in
            if let imgView = self.arrangedSubviews[idx] as? UIImageView {
                imgView.image = UIImage(systemName: "star.fill")
            }
        }

        if floatingRatingCount > 0.5 {
            if let imgView = self.arrangedSubviews[integerRatingCount] as? UIImageView {
                imgView.image = UIImage(systemName: "star.lefthalf.fill")
            }
        }
    }
}
