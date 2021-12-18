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
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } 
        }
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.f", self)
    }

    func toStringDecimal() -> String {
        return String(format: "%.2f", self)
    }

    func toWeek() -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func toHour() -> String {
        if self < Date().timeIntervalSince1970  {
            return "Now"
        }
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "ha"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }

    func toHourMinute() -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "h:mma"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}

extension String {
    func percent() -> String {
        return self.appending("%")
    }
    
    func celsius() -> String {
        return self.appending("°")
//        return self.appending("˚")
    }
}

extension UIView {
    var viewWidth: CGFloat {
        return self.frame.size.width
    }
    var viewHeight: CGFloat {
        return self.frame.size.height
    }
    var viewX: CGFloat {
        return self.frame.origin.x
    }
    var viewY: CGFloat {
        return self.frame.origin.y
    }
    func viewSet(x: CGFloat) {
        self.frame = CGRect(x: x, y: self.viewY, width: self.viewWidth, height: self.viewHeight)
    }
    func viewSet(y: CGFloat) {
        self.frame = CGRect(x: self.viewX, y: y, width: self.viewWidth, height: self.viewHeight)
    }
    func viewSet(widht: CGFloat) {
        self.frame = CGRect(x: self.viewX, y: self.viewY, width: widht, height: self.viewHeight)
    }
    func viewSet(height: CGFloat) {
        self.frame = CGRect(x: self.viewX, y: self.viewY, width: self.viewWidth, height: height)
    }
}


