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
            realm.add(gasStation)
        }
    }
    
     func deleteObject(_ gasStation: GasStation) {
           
           try! realm.write {
               realm.delete(gasStation)
           }
       }
    
}
