//
//  Validators.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 31.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//


import Foundation

enum TypeOfField {
    case quality, cost
}

class Validators {
    
    static func isFilled(name: String?, quality: String?, cost: String?, supplier: String?, address: String?) -> Bool {
        guard let name = name,
            let quality = quality,
            let cost = cost,
            let supplier = supplier,
            let address = address,
            name != "",
            quality != "",
            cost != "",
            supplier != "",
            address != "Choose an address"
            else { return false }
        return true
    }
    
    static func qualityIsValid(quality: String?) -> Bool {
        guard let quality = quality else { return false}
        let qualityRegEx = "[1-5]"
        let qualityPred = NSPredicate(format:"SELF MATCHES %@", qualityRegEx)
        return qualityPred.evaluate(with: quality)
    }
    
    
    static func emailIsValid(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func addressIsValid(address: String?) -> Bool {
        guard let address = address else { return false }
        return address.areLettersHere()
    }
}
