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
    var segmentedContoller: UISegmentedControl!
    let gasStationsViewController = GasStationsTableViewController()
    let infoViewController = InfoTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSegmentedController()
        setupConstraints()
        
        self.title = "TrackEnsure"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGasStation))
        self.navigationItem.rightBarButtonItem = addButton
        
        addChildControllers()
                
    }
    
    
    private func addChildControllers() {
        addChildVC(vc: gasStationsViewController)
    }
    
    private func addChildVC(vc: UIViewController) {
        
        guard let vcView = vc.view else { return }
         view.addSubview(vcView)
         vcView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             vcView.topAnchor.constraint(equalTo: segmentedContoller.bottomAnchor, constant: 30),
             vcView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             vcView.widthAnchor.constraint(equalToConstant: view.frame.width)
         ])
        
        self.addChild(vc)
        vc.didMove(toParent: self)
        
    }
    
    private func setupSegmentedController() {
        switchView = UISegmentedControl(items: items)
        switchView?.selectedSegmentIndex = 0
        switchView?.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
    }
    
    @objc private func segmentControl() {
        switch switchView?.selectedSegmentIndex {
        case 0:
            self.removeChild()
            self.addChildControllers()
        case 1:
            self.removeChild()
            self.addChildVC(vc: infoViewController)
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
        segmentedContoller = switchView
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


extension UIViewController {

    func removeChild() {
        guard parent != nil else {
             return
         }
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}
