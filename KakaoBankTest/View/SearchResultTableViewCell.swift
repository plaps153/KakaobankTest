//
//  SearchResultTableViewCell.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/22.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var screenshotStackView: UIStackView!
    @IBOutlet weak var lbRatingCount: UILabel!
    @IBOutlet weak var lbPrimaryGenreName: UILabel!

    @IBOutlet weak var ratingStackView: RatingStackView!
    var result: SearchResult?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(with result: SearchResult) {
        self.result = result

        self.selectionStyle = .none
        self.imgMain.image = nil
        self.imgMain.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.screenshotStackView.arrangedSubviews.forEach {
            if let v = $0 as? UIImageView {
                v.image = nil
                v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }

        self.lbTitle.text = result.trackCensoredName
        self.lbRatingCount.text = Parser.getRatingCount(with: result)
        self.ratingStackView.rating(with: result)

        if let pGenre = result.primaryGenreName {
            lbPrimaryGenreName.text = pGenre
        }
        
        DispatchQueue.global().async {
            if let artworkUrl = result.artworkUrl512,
                let url = URL(string: artworkUrl),
                let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imgMain.image = UIImage(data: data)
                    self.imgMain.layer.cornerRadius = 15
                    self.imgMain.clipsToBounds = true
                }
            }

            if let screenshoturls = result.screenshotUrls {
                for (i,_url) in screenshoturls.enumerated() {
                    if let url = URL(string: _url),
                        let data = try? Data(contentsOf: url),
                        let img = UIImage(data: data) {

                        DispatchQueue.main.async {

                            guard self.screenshotStackView.arrangedSubviews.count > i, let iv = self.screenshotStackView.arrangedSubviews[i] as? UIImageView else { return }

                            UIView.transition(with: iv, duration: 0.1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                                iv.image = img
                                iv.layer.cornerRadius = 15
                                iv.clipsToBounds = true
                            }) { (result) in

                            }
                        }
                    }
                }
            }
        }
    }
}
