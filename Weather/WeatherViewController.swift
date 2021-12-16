//
//  WeatherViewController.swift
//  Weather
//
//  Created by Sergey Vishnyov on 15.12.21.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var weatherTableView: UITableView!
    var daysArray = [DayEntity]()
    let cellReuseIdentifier = "DayTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil),
                                  forCellReuseIdentifier: cellReuseIdentifier)
        
        loadData()
    }
    
//    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
//        loadData()
//    }

    func loadData() {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/onecall?appid=e4b636bde533ce124b0334332e698026&lat=53.893009&lon=27.567444&lang=ru&units=metric&exclude=minutely")!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(response as Any)
                return
            }
            guard let data = data else { return }

            if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let currentDict = dict["current"] as? [String: Any] {
                    let day = DayEntity.init(currentDict)
                    self.daysArray.append(day)
                }
            }
            
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
//            guard let list = dictionaryObj["list"] as? [[String: Any]] else {
//
//                return
//            }
//
//            if let first = list.first, let wind = first["wind"] {
//                print(wind)
//            }
        }).resume()
    }
    
// MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DayTableViewCell
        let day = daysArray[indexPath.row]
        cell.set(day)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

