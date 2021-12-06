//
//  DeviceCollectionViewCell.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View
    
    private var stackViewIconAndName: UIStackView!
    private var imageViewIcon: UIImageView!
    private var labelName: UILabel!
    
    private var viewValue: UIView!
    private var labelValue: UILabel!
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    // MARK: - Configure
    
    func configure(with device: Device) {
        labelName.text = device.name
        
        switch device {
        case let light as Light:
            configure(withLight: light)
            
        case let rollerShutter as RollerShutter:
            configure(withRollerShutter: rollerShutter)
            
        case let heater as Heater:
            configure(withHeater: heater)
            
        default:
            imageViewIcon.image = nil
            labelValue.text = nil
        }
        
        if let text = labelValue.text, !text.isEmpty {
            viewValue.isHidden = false
        } else {
            viewValue.isHidden = true
        }
    }
    
    private func configure(withLight light: Light) {
        if light.mode {
            imageViewIcon.image = UIImage(named: "DeviceLightOnIcon")
            labelValue.text = "\(light.intensity)"
        } else {
            imageViewIcon.image = UIImage(named: "DeviceLightOffIcon")
            labelValue.text = nil
        }
    }
    
    private func configure(withRollerShutter rollerShutter: RollerShutter) {
        imageViewIcon.image = UIImage(named: "DeviceRollerShutterIcon")
        labelValue.text = "\(rollerShutter.position)"
    }
    
    private func configure(withHeater heater: Heater) {
        if heater.mode {
            imageViewIcon.image = UIImage(named: "DeviceHeaterOnIcon")
            labelValue.text = heater.temperature.toString() + "°"
        } else {
            imageViewIcon.image = UIImage(named: "DeviceHeaterOffIcon")
            labelValue.text = nil
        }
    }
}

// MARK: - View
private extension DeviceCollectionViewCell {
    
    func loadView() {
        setupImageViewIcon()
        setupLabelName()
        setupStackViewIconAndName()
        
        setupLabelValue()
        setupViewValue()
        
        setupMainView()
    }
    
    func setupImageViewIcon() {
        imageViewIcon = UIImageView()
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageViewIcon.widthAnchor.constraint(equalToConstant: 60),
            imageViewIcon.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.textColor = UIColor(named: "Black")
        labelName.textAlignment = .center
        labelName.font = UIFont.systemFont(ofSize: 15)
        labelName.numberOfLines = 2
    }
    
    func setupStackViewIconAndName() {
        stackViewIconAndName = UIStackView()
        stackViewIconAndName.translatesAutoresizingMaskIntoConstraints = false
        stackViewIconAndName.axis = .vertical
        stackViewIconAndName.alignment = .center
        stackViewIconAndName.distribution = .equalSpacing
        stackViewIconAndName.spacing = 20
        
        stackViewIconAndName.addArrangedSubview(imageViewIcon)
        stackViewIconAndName.addArrangedSubview(labelName)
    }
    
    func setupLabelValue() {
        labelValue = UILabel()
        labelValue.translatesAutoresizingMaskIntoConstraints = false
        labelValue.textColor = UIColor(named: "Black")
        labelValue.font = UIFont.systemFont(ofSize: 10)
    }
    
    func setupViewValue() {
        viewValue = UIView()
        viewValue.translatesAutoresizingMaskIntoConstraints = false
        viewValue.backgroundColor = UIColor(named: "Gray")
        viewValue.layer.cornerRadius = 10
        
        viewValue.layer.shadowColor = UIColor(named: "Black")?.cgColor
        viewValue.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewValue.layer.shadowOpacity = 0.15
        viewValue.layer.shadowRadius = 3
        
        viewValue.addSubview(labelValue)
        
        NSLayoutConstraint.activate([
            labelValue.topAnchor.constraint(equalTo: viewValue.topAnchor, constant: 5),
            labelValue.bottomAnchor.constraint(equalTo: viewValue.bottomAnchor, constant: -5),
            labelValue.leadingAnchor.constraint(equalTo: viewValue.leadingAnchor, constant: 10),
            labelValue.trailingAnchor.constraint(equalTo: viewValue.trailingAnchor, constant: -10),
        ])
    }
    
    func setupMainView() {
        backgroundColor = UIColor(named: "White")
        
        layer.cornerRadius = 5
        
        layer.shadowColor = UIColor(named: "Black")?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 5)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        
        addSubview(stackViewIconAndName)
        addSubview(viewValue)
        
        NSLayoutConstraint.activate([
            stackViewIconAndName.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewIconAndName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackViewIconAndName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            viewValue.bottomAnchor.constraint(equalTo: imageViewIcon.topAnchor, constant: 15),
            viewValue.leadingAnchor.constraint(equalTo: imageViewIcon.trailingAnchor, constant: -15),
        ])
    }
}
