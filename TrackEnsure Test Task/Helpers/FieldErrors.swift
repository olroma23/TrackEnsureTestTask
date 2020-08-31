//
//  FieldErrors.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 31.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

enum UserError {
    case cost, quality, empty
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cost:
            return NSLocalizedString("Please, enter the cost", comment: "")
        case .quality:
            return NSLocalizedString("Please, rate from 1 to 5", comment: "")
        case .empty:
            return NSLocalizedString("Please, fill all fields", comment: "")
        }
    }
}

