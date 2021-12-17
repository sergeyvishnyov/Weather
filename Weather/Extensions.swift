//
//  Extensions.swift
//  Weather
//
//  Created by Sergey Vishnyov on 15.12.21.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib <T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}

extension UIImageView {
    func loadImageFrom(_ url: URL) {
        self.image = nil
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
}

extension Int {
    func toString() -> String {
        return String(format: "%", self)
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.0f", self)
    }
    
    func toWeek() -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func toHour() -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "ha"
        if self < Date().timeIntervalSince1970  {
            return "Now"
        }
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}

