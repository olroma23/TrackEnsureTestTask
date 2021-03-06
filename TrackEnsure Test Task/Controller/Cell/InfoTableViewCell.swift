//
//  InfoTableViewCell.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

     let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let quantityLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let costLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let supplierlabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var gasStation : GasStation? {
        didSet {
            guard let name = gasStation?.name, let quality = gasStation?.quality, let cost = gasStation?.cost, let supplier = gasStation?.supplier else { return }
                 nameLabel.text = name
                 quantityLabel.text = "Q-ty: \(quality)"
                 costLabel.text = "cost: \(cost)"
                 supplierlabel.text = "Supplier: \(supplier)"        }
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
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        supplierlabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(nameLabel)
        self.addSubview(quantityLabel)
        self.addSubview(costLabel)
        self.addSubview(supplierlabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            quantityLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            quantityLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            costLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            supplierlabel.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 15),
            supplierlabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30)

            
        ])
    }

}
