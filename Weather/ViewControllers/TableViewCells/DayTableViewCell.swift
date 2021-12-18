//
//  DayTableViewCell.swift
//  Weather
//
//  Created by Sergey Vishnyov on 15.12.21.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    @IBOutlet var dayNameLabel: UILabel!
    @IBOutlet var dayImageView: UIImageView!
    @IBOutlet var dayTemeratureMinLabel: UILabel!
    @IBOutlet var dayTemeratureMaxLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ day: DayEntity) {
        dayTemeratureMaxLabel.text = day.tempDay?.toString()
        dayTemeratureMinLabel.text = day.tempNight?.toString()
        
        if day.currentDay == false {
            dayNameLabel.text = day.dt?.toWeek()
            dayImageView.isHidden = false
            guard let url = day.weather?.iconUrl else { return }
            dayImageView.loadImageFrom(url)
        } else {
            dayNameLabel.text = day.dt?.toWeek().appending(" Today")
            dayImageView.isHidden = true
        }
    }
}
