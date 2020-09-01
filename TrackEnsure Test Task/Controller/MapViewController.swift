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
    let costTF = CustomTextFields()
    let qualityTF = CustomTextFields()
    let supplierTF = CustomTextFields()
    
    var addressLabel = UILabel()
    var changeAddressButton = UIButton(type: .system)
    let locationButton = UIButton(type: .system)
    
    let mapView = MKMapView()
    
    var isActive = true
    
    var tapOnMap: UITapGestureRecognizer!
    
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
        
        qualityTF.keyboardType = UIKeyboardType.numberPad
        costTF.keyboardType = UIKeyboardType.decimalPad
        
        setupStyles()
        setupConstraints()
        
        //        mapView.delegate = self
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "New gas station"
        configureInfo(currentGasStation: currentGasStation)
        
        changeAddressButton.addTarget(self, action: #selector(changeAddressButtonPressed), for: .touchUpInside)
        
        locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        
        tapOnMap = UITapGestureRecognizer(target: self, action: #selector(tapOnMapAction))
        tapOnMap.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(tapOnMap)
        
        if !isActive {
            changeAddressButton.isHidden = false
        } else {
            changeAddressButton.isHidden = true
        }
    }
    
    @objc private func tapOnMapAction(tapOnMap: UITapGestureRecognizer){
        
        getAddressByTap(tapOnMap: tapOnMap, mapView: mapView)
        
    }
    
    @objc private func saveButtonPressed() {
        
        guard Validators.isFilled(name: nameTF.text!, quality: qualityTF.text!, cost: costTF.text!, supplier: supplierTF.text!, address: addressLabel.text) else {
            self.showAlert(title: "Error", message: "Please, fill all fields")
            return
        }
        
        guard Validators.qualityIsValid(quality: qualityTF.text!) else {
            self.showAlert(title: "Error", message: "Please, rate from 1 to 5")
            return
        }
        
        guard let costDouble = costTF.text?.doubleValue, costDouble != 0.0 else {
            showAlert(title: "Error", message: "Please, enter correct price")
            return
        }
        
        guard Validators.addressIsValid(address: addressLabel.text) else {
            self.showAlert(title: "Error", message: "Please, choose valid address")
            return
        }
        
        let newGasStation = GasStation(name: nameTF.text!, address: addressLabel.text!, supplier: supplierTF.text!, cost: "\(costDouble)", quality: qualityTF.text!)
        
        if currentGasStation != nil {
            
            try! realm.write {
                currentGasStation?.name = nameTF.text!
                currentGasStation?.cost = "\(costDouble)"
                currentGasStation?.address = addressLabel.text
                currentGasStation?.quality = qualityTF.text
                currentGasStation?.supplier = supplierTF.text
                FirestoreService.shared.editData(gasStation: currentGasStation!)
            }
            
        } else {
            StorageManager.shared.saveObject(newGasStation)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeAddressButtonPressed() {
        isActive = true
        changeAddressButton.isHidden = true
    }
    
    @objc private func locationButtonPressed() {
        mapManager.checkLocationServices(mapView: mapView) {
            mapManager.showUserLocation(mapView: mapView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureInfo(currentGasStation: GasStation?) {
        guard let currentGasStation = currentGasStation else { return }
        guard let cost = currentGasStation.cost, let supplier = currentGasStation.supplier, let quality = currentGasStation.quality, let address = currentGasStation.address else { return }
        isActive = false
        nameTF.text = currentGasStation.name
        costTF.text = cost
        qualityTF.text = quality
        supplierTF.text = supplier
        addressLabel.text = address
        self.title = "Edit gas station"
        mapManager.setupPlacemark(gasStation: currentGasStation, mapView: mapView)
    }
    
    private func getAddressByTap(tapOnMap: UITapGestureRecognizer, mapView: MKMapView) {
        
        if isActive {
            
            changeAddressButton.isHidden = true
            
            let location = mapManager.addressOnTap(tapOnMap: tapOnMap, mapView: mapView)
            
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
                let latitude = placemark?.location?.coordinate.latitude
                let longitude = placemark?.location?.coordinate.longitude
                
                DispatchQueue.main.async {
                    mapView.removeAnnotations(mapView.annotations)
                    self.mapManager.setupPlacemark(location: location, mapView: mapView)
                    if streetName != nil && buildNum != nil {
                        self.addressLabel.text = "\(streetName!), \(buildNum!)"
                    } else if streetName != nil {
                        self.addressLabel.text = "\(streetName!)"
                    } else {
                        self.addressLabel.text = "\(latitude!)" + ", " + "\(longitude!)"
                    }
                }
            }
        }
    }
    
    
    
}


//MARK: - MKMapViewDelegate

//extension MapViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//                if isActive {
//
//                    changeAddressButton.isHidden = true
//                    pinCenterImage.image = UIImage(systemName: "mappin", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
//
//                    let location = mapManager.getCenterLocation(for: mapView)
//                    let geocoder = CLGeocoder()
//
//                    geocoder.cancelGeocode()
//
//                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//                        if let error = error {
//                            print(error)
//                            return
//                        }
//
//                        guard let placemarks = placemarks else { return }
//                        let placemark = placemarks.first
//                        let streetName = placemark?.thoroughfare
//                        let buildNum = placemark?.subThoroughfare
//                        let latitude = placemark?.location?.coordinate.latitude
//                        let longitude = placemark?.location?.coordinate.longitude
//
//                        DispatchQueue.main.async {
//                            if streetName != nil && buildNum != nil {
//                                self.addressLabel.text = "\(streetName!), \(buildNum!)"
//                            } else if streetName != nil {
//                                self.addressLabel.text = "\(streetName!)"
//                            } else {
//                                self.addressLabel.text = "\(latitude!)" + ", " + "\(longitude!)"
//                            }
//                        }
//                    }
//                }
//    }
//
//
//}


// MARK: - Setup Constraints and Styles

extension MapViewController {
    
    private func setupStyles() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.frame = self.view.bounds
        blurredView.backgroundColor = .systemBackground
        blurredView.alpha = 0.65
        
        containerView.addSubview(blurredView)
        
        nameTF.applyStyles(style: .name, placeholder: "Enter the name")
        qualityTF.applyStyles(style: .quality, placeholder: "Quality (1-5)")
        costTF.applyStyles(style: .cost, placeholder: "Enter the cost of 1lit.")
        supplierTF.applyStyles(style: .supplier, placeholder: "Enter the supplier")
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(addressLabel)
        addressLabel.font = UIFont.boldSystemFont(ofSize: 15)
        addressLabel.textColor = .label
        addressLabel.text = "Choose an address"
        
        changeAddressButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(changeAddressButton)
        changeAddressButton.setTitle("Change address", for: .normal)
        
        let locationImage = UIImage(systemName: "location", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        locationButton.setImage(locationImage, for: .normal)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(locationButton)
        
    }
    
    private func setupConstraints() {
        
        let stackView = UIStackView(arrangedSubviews: [nameTF, qualityTF, costTF, supplierTF],
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
            
            addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            changeAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeAddressButton.topAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -50),
            
            locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            locationButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30)
        ])
    }
    
}


// MARK: - Show Alert

extension MapViewController {
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
}
