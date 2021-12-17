//
//  DetailTableViewCell.swift
//  Weather
//
//  Created by Sergey Vishnyov on 17.12.21.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {
    @IBOutlet var keyabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ current: HourEntity) {
        keyabel.text = "1"
        valueLabel.text = "2"
        
//        hourLabel.text = hour.dt?.toHour()
//        hourTemeratureLabel.text = hour.temp?.toString().appending("˚")
//
//        guard let url = hour.weather?.iconUrl else { return }
//        hourImageView.loadImageFrom(url)
    }

}
