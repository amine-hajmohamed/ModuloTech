//
//  DevicesFilterView.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 06/12/2021.
//

import UIKit
import RxSwift

private let kButtonWidth: CGFloat = 60
private let kButtonHeight: CGFloat = 30
private let kButtonCornerRadius: CGFloat = 10

class DevicesFilterView: UIView {
    
    // MARK: - View
    
    private var stackView: UIStackView!
    private var buttonAll: UIButton!
    private var buttonLight: UIButton!
    private var buttonRollerShutter: UIButton!
    private var buttonHeater: UIButton!
    
    // MARK: - Properties
    
    private let selectedDeviceTypesSubject = BehaviorSubject<Set<DeviceType>>(value: [])
    var selectedDeviceTypesObservable: Observable<Set<DeviceType>> { selectedDeviceTypesSubject.asObserver() }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        loadView()
        observe()
    }
    
    // MARK: - Observe
    
    private func observe() {
        selectedDeviceTypesSubject
            .subscribe(onNext: { [weak self] selectedDeviceTypes in
                self?.updateButtons(withSelectedDeviceTypes: selectedDeviceTypes)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update
    
    func updateButtons(withSelectedDeviceTypes selectedDeviceTypes: Set<DeviceType>) {
        updateButtonBackgroundColor(buttonAll, isSelected: selectedDeviceTypes.isEmpty)
        updateButtonBackgroundColor(buttonLight, isSelected: selectedDeviceTypes.contains(DeviceType.light))
        updateButtonBackgroundColor(buttonRollerShutter, isSelected: selectedDeviceTypes.contains(DeviceType.rollerShutter))
        updateButtonBackgroundColor(buttonHeater, isSelected: selectedDeviceTypes.contains(DeviceType.heater))
    }
    
    func updateButtonBackgroundColor(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor(named: "LightSteelBlue")
        } else {
            button.backgroundColor = UIColor(named: "LightGray")
        }
    }
}

// MARK: - Filter
private extension DevicesFilterView {
    
    func addSelectedDeviceType(_ deviceType: DeviceType, removeIfExist: Bool = true) {
        var selectedDeviceTypes = (try? selectedDeviceTypesSubject.value()) ?? []
        
        if removeIfExist && selectedDeviceTypes.contains(deviceType) {
            selectedDeviceTypes.remove(deviceType)
        } else {
            selectedDeviceTypes.insert(deviceType)
        }
        
        if selectedDeviceTypes.contains(DeviceType.light) &&
            selectedDeviceTypes.contains(DeviceType.rollerShutter) &&
            selectedDeviceTypes.contains(DeviceType.heater) {
            selectedDeviceTypes = []
        }
        
        selectedDeviceTypesSubject.onNext(selectedDeviceTypes)
    }
    
    func clearSelectedDeviceTypes() {
        selectedDeviceTypesSubject.onNext([])
    }
}

// MARK: - Actions
extension DevicesFilterView {
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case buttonAll:
            clearSelectedDeviceTypes()
            
        case buttonLight:
            addSelectedDeviceType(.light)
            
        case buttonRollerShutter:
            addSelectedDeviceType(.rollerShutter)
            
        case buttonHeater:
            addSelectedDeviceType(.heater)
            
        default:
            break
        }
    }
}

// MARK: - View

private extension DevicesFilterView {
    
    func loadView() {
        setupButtonAll()
        setupButtonLight()
        setupButtonRollerShutter()
        setupButtonHeater()
        setupStackView()
        setupMainView()
    }
    
    func setupButtonAll() {
        buttonAll = UIButton()
        buttonAll.translatesAutoresizingMaskIntoConstraints = false
        setupButtonTitle(buttonAll, title: "All".localized)
        setupButtonSizeAndLayer(buttonAll)
        buttonAll.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupButtonLight() {
        buttonLight = UIButton()
        buttonLight.translatesAutoresizingMaskIntoConstraints = false
        setupButtonImageView(buttonLight, imageName: "DeviceLightOnIcon")
        setupButtonSizeAndLayer(buttonLight)
        buttonLight.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupButtonRollerShutter() {
        buttonRollerShutter = UIButton()
        buttonRollerShutter.translatesAutoresizingMaskIntoConstraints = false
        setupButtonImageView(buttonRollerShutter, imageName: "DeviceRollerShutterIcon")
        setupButtonSizeAndLayer(buttonRollerShutter)
        buttonRollerShutter.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupButtonHeater() {
        buttonHeater = UIButton()
        buttonHeater.translatesAutoresizingMaskIntoConstraints = false
        setupButtonImageView(buttonHeater, imageName: "DeviceHeaterOnIcon")
        setupButtonSizeAndLayer(buttonHeater)
        buttonHeater.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupButtonTitle(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func setupButtonImageView(_ button: UIButton, imageName: String) {
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func setupButtonSizeAndLayer(_ button: UIButton) {
        button.layer.cornerRadius = kButtonCornerRadius
        
        button.layer.shadowColor = UIColor(named: "Black")?.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 3)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 3
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: kButtonWidth),
            button.heightAnchor.constraint(equalToConstant: kButtonHeight),
        ])
    }
    
    func setupStackView() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        
        stackView.addArrangedSubview(buttonAll)
        stackView.addArrangedSubview(buttonLight)
        stackView.addArrangedSubview(buttonRollerShutter)
        stackView.addArrangedSubview(buttonHeater)
    }
    
    func setupMainView() {
        backgroundColor = UIColor(named: "White")
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
}
