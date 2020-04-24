//
//  ResultViewController.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/22.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class ResultViewController: UIViewController {

    var result: SearchResult?
    var disposeBag = DisposeBag()

    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbAgeDesc: UILabel!
    @IBOutlet weak var lbGenreDesc: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var lbUpdateDate: UILabel!
    @IBOutlet weak var lbRatingCount: UILabel!

    @IBOutlet weak var ratingStackView: RatingStackView!
    @IBOutlet weak var screenShotStackView: UIStackView!
    @IBOutlet weak var releaseNoteTextView: UITextView!
    @IBOutlet weak var descTextView: UITextView!

    @IBOutlet weak var btnDeveloper: UIButton!
    @IBOutlet weak var descHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnDescMore: UIButton! {
        didSet {
            self.btnDescMore.rx.tap.asDriver().drive(onNext: { (_) in
                self.descHeightConstraint.isActive = false
                self.btnDescMore.isHidden = true
            }).disposed(by: self.disposeBag)
        }
    }

    @IBOutlet weak var descViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMore: UIButton! {
        didSet {
            self.btnMore.rx.tap.asDriver().drive(onNext: { (_) in
                self.descViewHeightConstraint.isActive = false
                self.btnMore.isHidden = true
            }).disposed(by: self.disposeBag)
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        
        setup()
    }

    private func setup() {
        self.releaseNoteTextView.text = result?.releaseNotes
        self.releaseNoteTextView.isScrollEnabled = false

        self.descTextView.text = result?.description
        self.descTextView.isScrollEnabled = false

        self.btnDeveloper.setTitle(result?.artistName ?? "", for: .normal)

        self.lbTitle.text = result?.trackCensoredName
        self.lbSubTitle.text = result?.genres?.first

        self.lbVersion.text = "버전 " + (result?.version ?? "")

        self.lbAge.text = result?.contentAdvisoryRating
        self.lbAgeDesc.text = "연령"
        self.lbGenreDesc.text = result?.genres?.first

        self.lbCount.text = String(format: "%.1f", result?.averageUserRating ?? 0.0)
        self.ratingStackView.rating(with: result)

        self.lbUpdateDate.text = Parser.getUpdateDate(with: result)

        self.lbRatingCount.text = (Parser.getRatingCount(with: result) ?? "") + "개의 평가"

        DispatchQueue.global().async { [weak self] in

            guard let self = self else { return }

            if let artworkUrl = self.result?.artworkUrl512,
                let url = URL(string: artworkUrl),
                let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imgMain.image = UIImage(data: data)
                    self.imgMain.layer.cornerRadius = 15
                    self.imgMain.clipsToBounds = true
                }
            }

            if let screenshoturls = self.result?.screenshotUrls {
                for (i,_url) in screenshoturls.enumerated() {
                    if let url = URL(string: _url),
                        let data = try? Data(contentsOf: url),
                        let img = UIImage(data: data) {

                        DispatchQueue.main.async {
                            guard self.screenShotStackView.arrangedSubviews.count > i, let iv = self.screenShotStackView.arrangedSubviews[i] as? UIImageView else { return }
                            iv.image = img
                
                            iv.layer.cornerRadius = 15
                            iv.clipsToBounds = true
                        }
                    }
                }
            }
        }
    }
}
