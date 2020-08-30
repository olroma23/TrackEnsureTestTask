//
//  GasStation.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import RealmSwift


class GasStation: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var address: String?
    @objc dynamic var supplier: String?
    @objc dynamic var cost: String?
    @objc dynamic var quality: String?
    
    
//    @objc dynamic var id: String
    
    convenience init(name: String, address: String, supplier: String, cost: String, quality: String) {
        self.init()
        self.name = name
        self.address = address
        self.supplier = supplier
        self.cost = cost
        self.quality = quality
    }
    

    
    
    
}

