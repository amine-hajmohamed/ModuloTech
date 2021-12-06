//
//  DeviceControlViewController.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 03/12/2021.
//

import UIKit
import RxSwift

class DeviceControlViewController: UIViewController {
    
    // MARK: - View
    
    private var labelName: UILabel!
    private var imageViewIcon: UIImageView!
    private var labelValue: UILabel!
    private var sliderView: SliderView!
    private var buttonTurnOnOff: UIButton!
    private var stackViewIconAndValue: UIStackView!
    
    // MARK: - Properties
    
    var viewModel: DeviceControlViewModel?
    
    private var labelValueSuffix = ""
    private var showDecimalNumberIfEqualToZero = false
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitle()
        observe()
    }
    
    // MARK: - Observe
    
    private func observe() {
        viewModel?.nameObservable
            .subscribe(onNext: { [weak self] name in
                self?.labelName.text = name
            })
            .disposed(by: disposeBag)
        
        viewModel?.valueObservable
            .subscribe(onNext: { [weak self] value in
                self?.sliderView.updateValue(value)
                self?.updateLabelValue(withValue: value)
            })
            .disposed(by: disposeBag)
        
        viewModel?.modeObservable
            .subscribe(onNext: { [weak self] mode in
                self?.updateButtonTurnOnOff(withMode: mode)
                self?.updateSliderView(withMode: mode ?? true)
                self?.updateImageViewIcon(withMode: mode ?? true)
                self?.updateLabelValue(withMode: mode ?? true)
            })
            .disposed(by: disposeBag)
        
        sliderView.valueObservable
            .subscribe(onNext: { [weak self] value in
                self?.viewModel?.onValueChanged(value)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update
    
    private func updateTitle() {
        guard let deviceType = viewModel?.deviceType else {
            title = nil
            return
        }
        
        title = "\(deviceType)".localized
    }
    
    private func updateButtonTurnOnOff(withMode mode: Bool?) {
        guard let mode = mode else {
            buttonTurnOnOff.isHidden = true
            return
        }
        
        if mode {
            buttonTurnOnOff.setTitle("turn_off".localized, for: .normal)
        } else {
            buttonTurnOnOff.setTitle("turn_on".localized, for: .normal)
        }
        
        buttonTurnOnOff.isHidden = false
    }
    
    private func updateImageViewIcon(withMode mode: Bool) {
        switch viewModel?.deviceType {
        case is Light.Type:
            if mode {
                imageViewIcon.image = UIImage(named: "DeviceLightOnIcon")
            } else {
                imageViewIcon.image = UIImage(named: "DeviceLightOffIcon")
            }
            
        case is RollerShutter.Type:
            imageViewIcon.image = UIImage(named: "DeviceRollerShutterIcon")
            
        case is Heater.Type:
            if mode {
                imageViewIcon.image = UIImage(named: "DeviceHeaterOnIcon")
            } else {
                imageViewIcon.image = UIImage(named: "DeviceHeaterOffIcon")
            }
            
        default:
            imageViewIcon.image = nil
        }
    }
    
    private func updateLabelValue(withValue value: Float) {
        labelValue.text = value.toString(showDecimalNumberIfEqualToZero: showDecimalNumberIfEqualToZero) + labelValueSuffix
    }
    
    private func updateLabelValue(withMode mode: Bool) {
        if mode {
            labelValue.alpha = 1
        } else {
            labelValue.alpha = 0.7
        }
    }
    
    private func updateSliderView(withMode mode: Bool) {
        if mode {
            sliderView.isUserInteractionEnabled = true
            sliderView.alpha = 1
        } else {
            sliderView.isUserInteractionEnabled = false
            sliderView.alpha = 0.7
        }
    }
}

// MARK: - Actions
extension DeviceControlViewController {
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if sender == buttonTurnOnOff {
            viewModel?.onTurnOnOffTapped()
        }
    }
}

// MARK: - View
extension DeviceControlViewController {
    
    override func loadView() {
        super.loadView()
        
        setupViewConfigurations()
        
        setupLabelName()
        setupImageViewIcon()
        setupLabelValue()
        setupSliderView()
        setupButtonTurnOnOff()
        setupStackViewIconAndValue()
        setupMainView()
    }
    
    private func setupViewConfigurations() {
        if let deviceType = viewModel?.deviceType, deviceType is Heater.Type {
            labelValueSuffix = "°"
            showDecimalNumberIfEqualToZero = true
        }
    }
    
    private func setupLabelName() {
        labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.textColor = UIColor(named: "Black")
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.textAlignment = .center
        labelName.numberOfLines = 2
    }
    
    private func setupImageViewIcon() {
        imageViewIcon = UIImageView()
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageViewIcon.widthAnchor.constraint(equalToConstant: 100),
            imageViewIcon.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setupLabelValue() {
        labelValue = UILabel()
        labelValue.translatesAutoresizingMaskIntoConstraints = false
        labelValue.textColor = UIColor(named: "Black")
        labelValue.font = UIFont.systemFont(ofSize: 20)
        labelValue.textAlignment = .center
    }
    
    private func setupSliderView() {
        sliderView = SliderView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        switch viewModel?.deviceType {
        case is Light.Type:
            sliderView.configureWith(value: 0, minValue: 0, maxValue: 100, step: 1)
            
        case is RollerShutter.Type:
            sliderView.configureWith(value: 0, minValue: 0, maxValue: 100, step: 1)
            
        case is Heater.Type:
            sliderView.configureWith(value: 7, minValue: 7, maxValue: 28, step: 0.5, labelValueSuffix: "°")
            
        default:
            break
        }
    }
    
    private func setupButtonTurnOnOff() {
        buttonTurnOnOff = UIButton()
        buttonTurnOnOff.translatesAutoresizingMaskIntoConstraints = false
        buttonTurnOnOff.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        buttonTurnOnOff.backgroundColor = UIColor(named: "White")
        buttonTurnOnOff.setTitleColor(UIColor(named: "Black"), for: .normal)
        buttonTurnOnOff.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        buttonTurnOnOff.layer.cornerRadius = 20
        buttonTurnOnOff.layer.shadowColor = UIColor(named: "Black")?.cgColor
        buttonTurnOnOff.layer.shadowOffset = CGSize(width: 2, height: 5)
        buttonTurnOnOff.layer.shadowOpacity = 0.25
        buttonTurnOnOff.layer.shadowRadius = 5
        
        NSLayoutConstraint.activate([
            buttonTurnOnOff.widthAnchor.constraint(equalToConstant: 100),
            buttonTurnOnOff.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupStackViewIconAndValue() {
        stackViewIconAndValue = UIStackView()
        stackViewIconAndValue.translatesAutoresizingMaskIntoConstraints = false
        stackViewIconAndValue.axis = .vertical
        stackViewIconAndValue.alignment = .center
        stackViewIconAndValue.spacing = 20
        
        stackViewIconAndValue.addArrangedSubview(imageViewIcon)
        stackViewIconAndValue.addArrangedSubview(labelValue)
    }
    
    private func setupMainView() {
        view.backgroundColor = UIColor(named: "White")
        
        view.addSubview(labelName)
        view.addSubview(stackViewIconAndValue)
        view.addSubview(sliderView)
        view.addSubview(buttonTurnOnOff)
        
        NSLayoutConstraint.activate([
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelName.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            stackViewIconAndValue.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            stackViewIconAndValue.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sliderView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            sliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonTurnOnOff.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonTurnOnOff.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30)
        ])
    }
}
