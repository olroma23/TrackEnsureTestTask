//
//  StatisticsTableViewController.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 28.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import RealmSwift

class InfoTableViewController: UITableViewController {
    
    let cellid = "infoCell"
    var gasStations: Results<GasStation>!
    var groupedStations = [[GasStation]]()
    var groupedDict = [String : [GasStation]]()
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let results = realm.objects(GasStation.self)
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                self?.gasStations = realm.objects(GasStation.self)
            case .update(_, _,  _,  _):
                // Query results have changed, so apply them to the UITableView
                tableView.reloadData()
                self?.gasStations = realm.objects(GasStation.self)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        gasStations = realm.objects(GasStation.self)
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.backgroundColor = .systemBackground
        print("view did load")


    }
    
    deinit {
         notificationToken?.invalidate()
     }
    
    private func configDataSource() {
        tableView.reloadData()
        let stations = Array(gasStations)
         
         groupedDict = Dictionary(grouping: stations) { (station) -> String in
             return station.address!
         }
         
         let keys = groupedDict.keys.sorted()
         print(keys)
         
         keys.forEach { (key) in
             groupedStations.append(groupedDict[key]!)
         }
         
         groupedStations.forEach({
             $0.forEach({print($0)})
             print("-----------")
         })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configDataSource()
    }
    

    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupedStations.count > 0 {
            return groupedStations[section].count
        }
        return gasStations.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return groupedStations.count > 0 ? groupedStations[section].first?.address : " "
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedStations.count > 0 ? groupedStations.count : 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! InfoTableViewCell
        var currentGasStation: GasStation
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if groupedStations.count > 1 {
            currentGasStation = groupedStations[indexPath.section][indexPath.row]
        } else {
            currentGasStation = gasStations[indexPath.row]
        }
        
        cell.nameLabel.text = currentGasStation.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
