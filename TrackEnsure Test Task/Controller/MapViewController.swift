//
//  MapViewController.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let mapManager = MapManager()
    var currentGasStation: GasStation?
    let containerView = UIView()
    
    let nameTF = CustomTextFields()
    let priceTF = CustomTextFields()
    let qualityTF = CustomTextFields()
    let supplierTF = CustomTextFields()
    
    let pinCenterImage = UIImageView()
    var addressLabel = UILabel()
    var changeAddressButton = UIButton(type: .system)
    
    let mapView = MKMapView()
    
    var isActive = true
    
    init(gasStation: GasStation?) {
        super.init(nibName: nil, bundle: nil)
        guard let currentGasStation = gasStation else { return }
        self.currentGasStation = currentGasStation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyles()
        setupConstraints()
        
        mapView.delegate = self
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "New gas station"
        configureInfo(currentGasStation: currentGasStation)
        
        changeAddressButton.addTarget(self, action: #selector(changeAddressButtonPressed), for: .touchUpInside)
        
    }
    
    @objc private func saveButtonPressed() {
                
        let newGasStation = GasStation(name: nameTF.text!, address: addressLabel.text!, supplier: supplierTF.text!, cost: priceTF.text!, quality: qualityTF.text!)
        
        if currentGasStation != nil {
                    
            try! realm.write {
                guard let name = nameTF.text, let price = priceTF.text, let quality = qualityTF.text, let supplier = supplierTF.text, let address = addressLabel.text else { return }
                currentGasStation?.name = name
                currentGasStation?.cost = price
                currentGasStation?.address = address
                currentGasStation?.quality = quality
                currentGasStation?.supplier = supplier
                FirestoreService.shared.editData(gasStation: currentGasStation!)
            }
            
        } else {
            StorageManager.shared.saveObject(newGasStation)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func changeAddressButtonPressed() {
        isActive = true
        pinCenterImage.image = UIImage(systemName: "mappin", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        changeAddressButton.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureInfo(currentGasStation: GasStation?) {
        guard let currentGasStation = currentGasStation else { return }
        guard let price = currentGasStation.cost, let supplier = currentGasStation.supplier, let quality = currentGasStation.quality, let address = currentGasStation.address else { return }
        isActive = false
        nameTF.text = currentGasStation.name
        priceTF.text = price
        qualityTF.text = quality
        supplierTF.text = supplier
        addressLabel.text = address
        self.title = "Edit gas station"
        mapManager.setupPlacemark(gasStation: currentGasStation, mapView: mapView)
    }
    
}

//MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if isActive {
            
            changeAddressButton.isHidden = true
            pinCenterImage.image = UIImage(systemName: "mappin", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
            
            let location = mapManager.getCenterLocation(for: mapView)
            let geocoder = CLGeocoder()
            
            geocoder.cancelGeocode()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let placemarks = placemarks else { return }
                let placemark = placemarks.first
                let streetName = placemark?.thoroughfare
                let buildNum = placemark?.subThoroughfare
                
                DispatchQueue.main.async {
                    if streetName != nil && buildNum != nil {
                        self.addressLabel.text = "\(streetName!), \(buildNum!)"
                    } else if streetName != nil {
                        self.addressLabel.text = "\(streetName!)"
                    } else {
                        self.addressLabel.text = "Choose an address"
                    }
                }
            }
        }
    }
    
    
    
}


// MARK: Setup Constraints and Styles

extension MapViewController {
    
    private func setupStyles() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.frame = self.view.bounds
        blurredView.backgroundColor = .white
        blurredView.alpha = 0.7
        
        containerView.addSubview(blurredView)
        
        nameTF.applyStyles(style: .name, placeholder: "Enter the name")
        qualityTF.applyStyles(style: .quality, placeholder: "Quality (1-5)")
        priceTF.applyStyles(style: .cost, placeholder: "Enter the price of 1lit.")
        supplierTF.applyStyles(style: .supplier, placeholder: "Enter the supplier")
        
        pinCenterImage.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(pinCenterImage)
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(addressLabel)
        addressLabel.font = UIFont.boldSystemFont(ofSize: 15)
        addressLabel.textColor = .black
        addressLabel.text = "Choose an address"
        
        changeAddressButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(changeAddressButton)
        changeAddressButton.setTitle("Change address", for: .normal)
        
        
    }
    
    private func setupConstraints() {
        
        let stackView = UIStackView(arrangedSubviews: [nameTF, qualityTF, priceTF, supplierTF],
                                    axis: .vertical,
                                    spacing: 10)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.widthAnchor.constraint(equalToConstant: view.frame.width),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            pinCenterImage.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: 20),
            pinCenterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            changeAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeAddressButton.topAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -50)
        ])
    }
    
}
