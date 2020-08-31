//
//  MainViewController.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 28.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let items = ["Gas stations", "Info"]
    var switchView: UISegmentedControl?
    let gasStationsViewController = GasStationsTableViewController()
    let infoViewController = InfoTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        addChildControllers()
        setupSegmentedController()
        setupConstraints()
        
        self.title = "TrackEnsure"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGasStation))
        self.navigationItem.rightBarButtonItem = addButton

        
    }
    
    
    private func addChildControllers() {
        self.addChild(gasStationsViewController)
        self.addChild(infoViewController)
    }
    
    
    private func setupSegmentedController() {
        switchView = UISegmentedControl(items: items)
        switchView?.selectedSegmentIndex = 0
        gasStationsViewController.view.alpha = 1
        infoViewController.view.alpha = 0
        switchView?.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
    }
    
    @objc private func segmentControl() {
        switch switchView?.selectedSegmentIndex {
        case 0:
            gasStationsViewController.view.alpha = 1
            infoViewController.view.alpha = 0
        case 1:
            gasStationsViewController.view.alpha = 0
            infoViewController.view.alpha = 1
        default:
            print("Smth wrong")
        }
    }
    
    @objc private func addNewGasStation() {
        self.navigationController?.pushViewController(MapViewController(gasStation: nil), animated: true)
    }
    
    // MARK: Setup Constraints
    
    private func setupConstraints() {
        
        // segmentedControll
        guard let segmentedContoller = switchView else { return }
        view.addSubview(segmentedContoller)
        segmentedContoller.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedContoller.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            segmentedContoller.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedContoller.widthAnchor.constraint(equalToConstant: view.frame.width - 80)
        ])
        
        // Views
        guard let gasStationsView = gasStationsViewController.view else { return }
        view.addSubview(gasStationsView)
        gasStationsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gasStationsView.topAnchor.constraint(equalTo: segmentedContoller.bottomAnchor, constant: 30),
            gasStationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gasStationsView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        guard let infoView = infoViewController.view else { return }
        view.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: segmentedContoller.bottomAnchor, constant: 30),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
    }
}



// MARK: SwiftUI canvas mode

import SwiftUI

struct MainViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        typealias UIViewControllerType = MainViewController
        let mainViewController = MainViewController()
        
        func makeUIViewController(context: Context) -> MainViewController {
            return mainViewController
        }
        
        func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
            
        }
    }
}
