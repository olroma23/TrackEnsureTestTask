//
//  StorageManager.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 30.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    func saveObject(_ gasStation: GasStation) {
        
        try! realm.write {
            realm.add(gasStation, update: .all)
        }
        
        FirestoreService.shared.saveGasStationWith(gasStation: gasStation) { (result) in
            switch result {
            case .success(let gasStation):
                print(gasStation)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveOldObject(gasStation: GasStation, update: Bool) {
        
      try! realm.write {
        realm.add(gasStation, update: .modified)
        }


    }
        
        func deleteObject(_ gasStation: GasStation) {
            
            FirestoreService.shared.deleteGasStation(gasStation: gasStation) { (result) in
                switch result {
                case .success():
                    print("Deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            try! realm.write {
                realm.delete(gasStation)
            }
            
        }
        
    }

