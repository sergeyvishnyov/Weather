//
//  SunCollectionViewCell.swift
//  Weather
//
//  Created by Sergey Vishnyov on 18.12.21.
//

import UIKit

class SunCollectionViewCell: UICollectionViewCell {
    @IBOutlet var sunHourLabel: UILabel!
    @IBOutlet var sunImageView: UIImageView!
    @IBOutlet var sunLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    func set(_ hour: HourEntity) {
        if let sunset = hour.sunset {
            sunLabel.text = "Sunset"
            sunHourLabel.text = sunset.toHourMinute()
            sunImageView.image = #imageLiteral(resourceName: "sunset")
        }
        if let sunrise = hour.sunrise {
            sunLabel.text = "Sunrise"
            sunHourLabel.text = sunrise.toHourMinute()
            sunImageView.image = #imageLiteral(resourceName: "sunrise")
        }
    }

}
