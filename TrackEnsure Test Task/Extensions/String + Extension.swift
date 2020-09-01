//
//  String + Extension.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 31.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
     func areLettersHere() -> Bool {
         return self.rangeOfCharacter(from: CharacterSet.letters) != nil && self != ""
     }

}
