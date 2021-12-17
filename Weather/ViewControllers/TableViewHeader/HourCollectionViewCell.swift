//
//  HourCollectionViewCell.swift
//  Weather
//
//  Created by Sergey Vishnyov on 17.12.21.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var hourImageView: UIImageView!
    @IBOutlet var hourTemeratureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func set(_ hour: HourEntity) {
        hourLabel.text = hour.dt?.toHour()
        hourTemeratureLabel.text = hour.temp?.toString().appending("˚")
        
        guard let url = hour.weather?.iconUrl else { return }
        hourImageView.loadImageFrom(url)
    }
}
