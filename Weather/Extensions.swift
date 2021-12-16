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

extension Int {
    func toString() -> String {
        return String(format: "%", self)
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.0f", self)
    }
}

