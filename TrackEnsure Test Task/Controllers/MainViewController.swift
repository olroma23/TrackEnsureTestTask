//
//  MainViewController.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 28.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let items = ["Gas stations", "Statistics"]
    var switchView: UISegmentedControl?
    let gasStationsViewController = GasStationsTableViewController()
    let statisticsViewController = StatisticsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addChildControllers()
        setupSegmentedController()
        setupConstraints()
    }
    
    
    private func addChildControllers() {
        self.addChild(gasStationsViewController)
        self.addChild(statisticsViewController)
    }
    
//    func hideContentController(content: UIViewController?) {
//        guard let content = content else { return }
//        content.willMove(toParent: nil)
//        content.view.removeFromSuperview()
//        content.removeFromParent()
//        print("Removed: \(content)")
//    }
//

    private func setupSegmentedController() {
        switchView = UISegmentedControl(items: items)
        switchView?.selectedSegmentIndex = 0
        gasStationsViewController.view.alpha = 1
        statisticsViewController.view.alpha = 0
        switchView?.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
    }
    
    @objc private func segmentControl() {
        switch switchView?.selectedSegmentIndex {
        case 0:
            gasStationsViewController.view.alpha = 1
            statisticsViewController.view.alpha = 0
        case 1:
            gasStationsViewController.view.alpha = 0
            statisticsViewController.view.alpha = 1
        default:
            print("Smth wrong")
        }
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
        
        guard let statisticsView = statisticsViewController.view else { return }
        view.addSubview(statisticsView)
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: segmentedContoller.bottomAnchor, constant: 30),
            statisticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statisticsView.widthAnchor.constraint(equalToConstant: view.frame.width)
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
