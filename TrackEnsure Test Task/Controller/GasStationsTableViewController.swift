//
//  GasStationsTableViewController.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 28.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import RealmSwift

class GasStationsTableViewController: UITableViewController {
    
    var gasStations: Results<GasStation>!
    private let cellid = "gasStationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gasStations = realm.objects(GasStation.self)
        tableView.register(GasStationTableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStations.isEmpty ? 0 : gasStations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! GasStationTableViewCell
        let currentGasStation = gasStations[indexPath.row]
        cell.gasStation = currentGasStation
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentGasStation = gasStations[indexPath.row]
        print(currentGasStation)
        self.navigationController?.pushViewController(MapViewController(gasStation: currentGasStation), animated: true)
    }
    
    //    deleting rows
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentGasStation = gasStations[indexPath.row]
            StorageManager.shared.deleteObject(currentGasStation)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
}
