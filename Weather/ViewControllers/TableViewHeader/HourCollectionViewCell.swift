//
//  HourCollectionViewCell.swift
//  Weather
//
//  Created by Sergey Vishnyov on 17.12.21.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var hourPopLabel: UILabel!
    @IBOutlet var hourImageView: UIImageView!
    @IBOutlet var hourTemeratureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func set(_ hour: HourEntity) {
        hourLabel.text = hour.dt?.toHour()
        if let pop = hour.pop {
            hourPopLabel.isHidden = pop == 0
            hourPopLabel.text = (pop * 100).toString().percent()
        }
        hourTemeratureLabel.text = hour.temp?.toString().celsius()
        guard let url = hour.weather?.iconUrl else { return }
        hourImageView.loadImageFrom(url)
    }
}
