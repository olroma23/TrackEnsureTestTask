//
//  GasStationTableViewCell.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class GasStationTableViewCell: UITableViewCell {
    
    private let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let supplierLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var gasStation : GasStation? {
        didSet {
            nameLabel.text = gasStation!.name
            supplierLabel.text = gasStation!.supplier
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Setup Contraints and styles
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        supplierLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        self.addSubview(supplierLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 30),
            
            supplierLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            supplierLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            supplierLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 30),
        ])
    }
    
}
