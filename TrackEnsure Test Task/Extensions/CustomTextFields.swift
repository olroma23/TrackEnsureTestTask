//
//  CustomTextFields.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

enum Style {
    
    case name, cost, quality, supplier
}

class CustomTextFields: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.font = UIFont.systemFont(ofSize: 14)
        self.clearButtonMode = .whileEditing
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        self.borderStyle = .none
        self.backgroundColor = .systemRed
    }
        
    func applyStyles(style: Style, placeholder: String) {
        
        self.placeholder = placeholder
        
        var image: UIImage!
        var imageView: UIImageView!

        switch style {
            
        case .name:
            self.backgroundColor = .systemGray6
            image = UIImage(systemName: "flame", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
            imageView = UIImageView(image: image)
            
        case .cost:
            self.backgroundColor = .systemGray6
            image = UIImage(systemName: "dollarsign.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
            imageView = UIImageView(image: image)
        case .quality:
              self.backgroundColor = .systemGray6
                      image = UIImage(systemName: "hand.thumbsup.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
                      imageView = UIImageView(image: image)
        case .supplier:
              self.backgroundColor = .systemGray6
                      image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
                      imageView = UIImageView(image: image)
            
        }
        
        self.leftView = imageView
        self.leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        self.leftView?.alpha = 0.5
        leftViewMode = .always
        
        let button = UIButton(type: .system)
        self.rightView = button
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        self.rightViewMode = .always
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
