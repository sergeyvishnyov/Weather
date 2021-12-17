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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ day: DayEntity) {
//        dayNameLabel.text = day.dayWeek
        dayNameLabel.text = day.dt?.toWeek()
        dayTemeratureMaxLabel.text = day.tempDay?.toString()
        dayTemeratureMinLabel.text = day.tempNight?.toString()
        
        guard let url = day.weather?.iconUrl else { return }
        dayImageView.loadImageFrom(url)
    }
    
}
