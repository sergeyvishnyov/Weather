//
//  CurrentTableViewCell.swift
//  Weather
//
//  Created by Sergey Vishnyov on 17.12.21.
//

import UIKit

enum CurrentType: String, CaseIterable {
    case sunrize = "SINRIZE"
    case sunset = "SINSET"
    case pop = "PROBABILITI OF PRECIPITATION"
    case humdity = "HUMDITY"
    case wind = "WIND"
    case feels_like = "FEELS LIKE"
    case precipitation = "PRECIPITATION"
    case pressure = "PRESSURE"
    case visibility = "VISIBILITY"
    case uv_index = "UV INDEX"
}

class CurrentTableViewCell: UITableViewCell {
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ currentType: CurrentType, _ currentHour: HourEntity?) {
        keyLabel.text = currentType.rawValue
        if let hour = currentHour {
            var value: String?
            switch currentType {
            case .sunrize:
                value = hour.sunrise?.toHourMinute()
            case .sunset:
                value = hour.sunset?.toHourMinute()
            case .pop:
                value = (hour.pop! * 100).toString().percent()
            case .humdity:
                value = hour.humidity?.toString().percent()
            case .wind:
                guard let wind_deg = hour.wind_deg else { return }
                guard let speed = hour.wind_speed else { return }
                var direction: String! = ""
                if wind_deg > 0 && wind_deg <= 90 {
                    direction = "East"
                } else if wind_deg > 90 && wind_deg <= 180 {
                    direction = "South"
                } else if wind_deg > 180 && wind_deg <= 270 {
                    direction = "West"
                } else {
                    direction = "North"
                }
                value = direction + ", " + speed.toString().appending(" m/s")
            case .feels_like:
                value = hour.feels_like?.toString().celsius()
            case .precipitation:
                value = "0 mm"
                if let rain = hour.rain {
                    value = rain.toStringDecimal().appending(" mm")
                } else if let snow = hour.snow {
                    value = snow.toStringDecimal().appending(" mm")
                }
            case .pressure:
                if let pressure = hour.pressure {
                    value = pressure.toString().appending(" hPa")
                    value = value?.appending(", \(Int(pressure * 0.75006)) mmHg") // hPa to mmHg
                }
            case .visibility:
                if let visibility = hour.visibility {
    //                value = visibility.toString().appending(" metres")
                    value = (visibility / 1000.0).toStringDecimal().appending(" km")
                }
            case .uv_index:
                value = hour.uvi?.toString()
            }
            valueLabel.text = value
        }
    }
}
