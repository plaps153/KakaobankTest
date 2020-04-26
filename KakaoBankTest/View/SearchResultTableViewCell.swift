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
        
        self.lbTitle.text = result.trackCensoredName
        self.lbRatingCount.text = Parser.getRatingCount(with: result)
        self.ratingStackView.rating(with: result)
        
        if let pGenre = result.primaryGenreName {
            lbPrimaryGenreName.text = pGenre
        }
        
        DispatchQueue.main.async {
            if let artwork = result.asset["artwork"] {
                self.imgMain.image = artwork
            }
            self.imgMain.layer.cornerRadius = 15
            self.imgMain.clipsToBounds = true
            
            for (i,v) in self.screenshotStackView.arrangedSubviews.enumerated() {
                guard let iv = v as? UIImageView else { continue }
                
                guard let image = result.asset["screenshot\(i)"] else { continue }
             
                UIView.transition(with: iv, duration: 0.1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                    iv.image = image
                    iv.layer.cornerRadius = 15
                    iv.clipsToBounds = true
                })
            }
        }
    }
}
