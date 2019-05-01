//
//  CoinCollectionViewCell.swift
//  Coinbase Icons
//
//  Created by Paulo Fierro on 30/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import Kingfisher
import UIKit

class CoinCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!

    static let identifier = "coinCollectionViewCell"

    var coin: Coin? {
        didSet {
            guard let coin = coin, let url = URL(string: coin.iconURL) else { return }
            nameLabel.text = coin.name
            symbolLabel.text = coin.symbol
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
        }
    }

    // MARK: Constructors

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
