//
//  TableViewHeader.swift
//  Weather
//
//  Created by Sergey Vishnyov on 17.12.21.
//

import UIKit

class HoursCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let cellReuseIdentifierHour = "HourCollectionViewCell"
    let cellReuseIdentifierSun = "SunCollectionViewCell"
    var hours = [HourEntity]()

    override func draw(_ rect: CGRect) {
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        cgContext?.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        cgContext?.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        cgContext?.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        cgContext?.setStrokeColor(UIColor.groupTableViewBackground.cgColor)
        cgContext?.setLineWidth(1.0)
        cgContext?.strokePath()
        
        delegate = self
        dataSource = self
    }
    
    // MARK: - UICollectionViewDataSource delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hour = hours[indexPath.item]
        if hour.sunset == nil && hour.sunrise == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifierHour, for: indexPath) as! HourCollectionViewCell
            cell.set(hour)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifierSun, for: indexPath) as! SunCollectionViewCell
            cell.set(hour)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hour = hours[indexPath.item]
        return CGSize(width: hour.sunset == nil && hour.sunrise == nil ? 50 : 80,
                      height: 120)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }

}
