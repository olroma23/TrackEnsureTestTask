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

    override func viewDidLoad() {
        super.viewDidLoad()
        gasStations = realm.objects(GasStation.self)
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: cellid)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStations.isEmpty ? 0 : gasStations.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! InfoTableViewCell
        let currentGasStation = gasStations[indexPath.row]
        cell.gasStation = currentGasStation
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
