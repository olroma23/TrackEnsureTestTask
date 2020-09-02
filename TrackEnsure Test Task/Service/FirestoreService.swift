//
//  Firestore Service.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 30.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Firebase
import FirebaseFirestore
import RealmSwift

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
            "quality": gasStation.quality!,
            "uuid": gasStation.uuid ]) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully rewritten!")
                }
        }
        
    }
    
    
    func syncData(completion: @escaping(Result<Void, Error>) -> ()) {
        
        self.gasStationRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                let data = document.data()
                let dataModel = GasStation(name: data["name"]! as! String,
                                           address: data["address"]! as! String,
                                           supplier: data["supplier"]! as! String,
                                           cost: data["cost"]! as! String,
                                           quality: data["quality"]! as! String,
                                           uuid: data["uuid"]! as! String )
                StorageManager.shared.saveObject(gasStation: dataModel, update: true)

            }

            completion(.success(Void()))
        }
        
        
    }
    
    
    func getData(completion: @escaping(Result<[GasStation], Error>) -> ()) {
        

        self.gasStationRef.getDocuments { (querySnapshot, error) in
            var gasStations: [GasStation] = []
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                let data = document.data()
                print("data", data)
                let dataModel = GasStation(name: data["name"]! as! String,
                                           address: data["address"]! as! String,
                                           supplier: data["supplier"]! as! String,
                                           cost: data["cost"]! as! String,
                                           quality: data["quality"]! as! String,
                                           uuid: data["uuid"]! as! String )
                print("dataModel", dataModel)
                gasStations.append(dataModel)


            }

            completion(.success(gasStations))
        }


    }
    
    
    
    
}
