//
//  TableViewHeader.swift
//  Weather
//
//  Created by Sergey Vishnyov on 17.12.21.
//

import UIKit

class HoursCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    let cellReuseIdentifier = "HourCollectionViewCell"
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
    }
    
    // MARK: - UICollectionViewDataSource delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! HourCollectionViewCell

//        cell.backgroundColor = UIColor.white

        let hour = hours[indexPath.item]
        cell.set(hour)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
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
//        let vc = ProductViewController.loadFromNib()
//        vc.product = dataArray[indexPath.item]
//        navigationController!.pushViewController(vc, animated: true)
//    }

}
