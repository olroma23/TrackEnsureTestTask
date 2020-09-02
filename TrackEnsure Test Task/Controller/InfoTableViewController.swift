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
    var groupedStations = [[GasStation]]()
    var groupedDict = [String : [GasStation]]()
    var notificationToken: NotificationToken? = nil
    var gasStations = [GasStation]()
    
    //    let results = realm.objects(GasStation.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        realm.refresh()
        gasStations = Array(realm.objects(GasStation.self))
        tableView.reloadData()
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            self.configDataSource()
        }

        //                  Observe Results Notifications
        //        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
        //            guard let tableView = self?.tableView else { return }
        //            switch changes {
        //            case .initial:
        //                // Results are now populated and can be accessed without blocking the UI
        //                tableView.reloadData()
        //            case .update(_, let deletions, let insertions, let modifications):
        //                // Query results have changed, so apply them to the UITableView
        //                tableView.beginUpdates()
        //                // Always apply updates in the following order: deletions, insertions, then modifications.
        //                // Handling insertions before deletions may result in unexpected behavior.
        //                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
        //                                     with: .automatic)
        //                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
        //                                     with: .none)
        //                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
        //                                     with: .none)
        //                tableView.endUpdates()
        //            case .error(let error):
        //                // An error occurred while opening the Realm file on the background worker thread
        //                fatalError("\(error)")
        //            }
        //        }
        
        
    }
    
    
    
    private func configDataSource() {
        groupedDict = Dictionary(grouping: gasStations) { (station) -> String in
            return station.address!
        }
        
        let keys = groupedDict.keys.sorted()
        print(keys)
        
        keys.forEach { (key) in
            if !groupedStations.contains(groupedDict[key]!) {
                groupedStations.append(groupedDict[key]!)
            }
        }
        
        groupedStations.forEach({
            $0.forEach({print($0)})
            print("-----------")
        })
                
        tableView.reloadData()
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
        
        cell.gasStation = currentGasStation
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
}

