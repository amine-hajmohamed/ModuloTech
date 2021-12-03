//
//  DeviceCollectionViewCell.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View
    
    private var stackViewDeviceIconAndName: UIStackView!
    private var imageViewDeviceIcon: UIImageView!
    private var labelDeviceName: UILabel!
    
    private var viewDeviceValue: UIView!
    private var labelDeviceValue: UILabel!
    
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
        labelDeviceName.text = device.deviceName
        
        switch device {
        case let light as Light:
            configure(withLight: light)
            
        case let rollerShutter as RollerShutter:
            configure(withRollerShutter: rollerShutter)
            
        case let heater as Heater:
            configure(withHeater: heater)
            
        default:
            imageViewDeviceIcon.image = nil
            labelDeviceValue.text = nil
        }
        
        if let text = labelDeviceValue.text, !text.isEmpty {
            viewDeviceValue.isHidden = false
        } else {
            viewDeviceValue.isHidden = true
        }
    }
    
    private func configure(withLight light: Light) {
        if light.mode {
            imageViewDeviceIcon.image = UIImage(named: "DeviceLightOnIcon")
            labelDeviceValue.text = "\(light.intensity)"
        } else {
            imageViewDeviceIcon.image = UIImage(named: "DeviceLightOffIcon")
            labelDeviceValue.text = nil
        }
    }
    
    private func configure(withRollerShutter rollerShutter: RollerShutter) {
        imageViewDeviceIcon.image = UIImage(named: "DeviceRollerShutterIcon")
        labelDeviceValue.text = "\(rollerShutter.position)"
    }
    
    private func configure(withHeater heater: Heater) {
        if heater.mode {
            imageViewDeviceIcon.image = UIImage(named: "DeviceHeaterOnIcon")
            
            var stringFormat = "%.1f°"
            if heater.temperature.truncatingRemainder(dividingBy: 1) == 0 {
                stringFormat = "%.0f°"
            }
            labelDeviceValue.text = String(format: stringFormat, heater.temperature)
        } else {
            imageViewDeviceIcon.image = UIImage(named: "DeviceHeaterOffIcon")
            labelDeviceValue.text = nil
        }
    }
}

// MARK: - View
private extension DeviceCollectionViewCell {
    
    func loadView() {
        setupImageViewDeviceIcon()
        setupLabelDeviceName()
        setupStackViewDeviceIconAndName()
        
        setupLabelDeviceValue()
        setupViewDeviceValue()
        
        setupMainView()
    }
    
    // MARK: - Setup views
    
    func setupImageViewDeviceIcon() {
        imageViewDeviceIcon = UIImageView()
        imageViewDeviceIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewDeviceIcon.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageViewDeviceIcon.widthAnchor.constraint(equalToConstant: 60),
            imageViewDeviceIcon.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setupLabelDeviceName() {
        labelDeviceName = UILabel()
        labelDeviceName.translatesAutoresizingMaskIntoConstraints = false
        labelDeviceName.textAlignment = .center
        labelDeviceName.font = UIFont.systemFont(ofSize: 15)
        labelDeviceName.numberOfLines = 2
    }
    
    func setupStackViewDeviceIconAndName() {
        stackViewDeviceIconAndName = UIStackView()
        stackViewDeviceIconAndName.translatesAutoresizingMaskIntoConstraints = false
        stackViewDeviceIconAndName.axis = .vertical
        stackViewDeviceIconAndName.alignment = .center
        stackViewDeviceIconAndName.distribution = .equalSpacing
        stackViewDeviceIconAndName.spacing = 20
        
        stackViewDeviceIconAndName.addArrangedSubview(imageViewDeviceIcon)
        stackViewDeviceIconAndName.addArrangedSubview(labelDeviceName)
    }
    
    func setupLabelDeviceValue() {
        labelDeviceValue = UILabel()
        labelDeviceValue.translatesAutoresizingMaskIntoConstraints = false
        labelDeviceValue.font = UIFont.systemFont(ofSize: 10)
    }
    
    func setupViewDeviceValue() {
        viewDeviceValue = UIView()
        viewDeviceValue.translatesAutoresizingMaskIntoConstraints = false
        viewDeviceValue.backgroundColor = UIColor(named: "Gray")
        viewDeviceValue.layer.cornerRadius = 10
        
        viewDeviceValue.addSubview(labelDeviceValue)
        
        NSLayoutConstraint.activate([
            labelDeviceValue.topAnchor.constraint(equalTo: viewDeviceValue.topAnchor, constant: 5),
            labelDeviceValue.bottomAnchor.constraint(equalTo: viewDeviceValue.bottomAnchor, constant: -5),
            labelDeviceValue.leadingAnchor.constraint(equalTo: viewDeviceValue.leadingAnchor, constant: 10),
            labelDeviceValue.trailingAnchor.constraint(equalTo: viewDeviceValue.trailingAnchor, constant: -10),
        ])
    }
    
    func setupMainView() {
        backgroundColor = UIColor(named: "White")
        
        layer.cornerRadius = 5
        
        layer.shadowColor = UIColor(named: "Black")?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 5)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        
        addSubview(stackViewDeviceIconAndName)
        addSubview(viewDeviceValue)
        
        NSLayoutConstraint.activate([
            stackViewDeviceIconAndName.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewDeviceIconAndName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackViewDeviceIconAndName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            viewDeviceValue.bottomAnchor.constraint(equalTo: imageViewDeviceIcon.topAnchor, constant: 15),
            viewDeviceValue.leadingAnchor.constraint(equalTo: imageViewDeviceIcon.trailingAnchor, constant: -15),
        ])
    }
}
