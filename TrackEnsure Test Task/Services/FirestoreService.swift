//
//  Firestore Service.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 30.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    var gasStation: GasStation!
    
    private var gasStationRef: CollectionReference {
        return db.collection("gasStations")
    }
    
    func saveGasStationWith(gasStation: GasStation, completion: @escaping (Result<GasStation, Error>) -> ()) {
        
        let gasStationDocumentName = [gasStation.name, gasStation.uuid].joined(separator: " ")
        self.gasStationRef.document(gasStationDocumentName).setData(gasStation.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(gasStation))
            }
        }
    }
    
    func deleteGasStation(gasStation: GasStation, completion: @escaping(Result<Void, Error>) -> ()) {
        let gasStationDocumentName = [gasStation.name, gasStation.uuid].joined(separator: " ")
        self.gasStationRef.document(gasStationDocumentName).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
    }
    
    
    func editData(gasStation: GasStation) {
        let gasStationDocumentName = [gasStation.name, gasStation.uuid].joined(separator: " ")
        
        self.gasStationRef.document(gasStationDocumentName).setData([
            "name": gasStation.name,
            "address": gasStation.address!,
            "supplier": gasStation.supplier!,
            "cost": gasStation.cost!,
            "quality": gasStation.quality!
            
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully rewritten!")
            }
        }

    }
    
    
}
