//
//  GasStation.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

struct GasStation: Hashable, Decodable {
    
    let name: String
    let address: String
    let supplier: String
    let cost: Double
    let quality: Int
    let id: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GasStation, rhs: GasStation) -> Bool {
        return lhs.id == rhs.id
    }
    
}

