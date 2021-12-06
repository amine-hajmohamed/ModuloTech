//
//  DevicesListViewModel.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import RxSwift

class DevicesListViewModel {
    
    // MARK: - Properties
    
    private let devicesSubject = BehaviorSubject<[Device]>(value: [])
    var devicesObservable: Observable<[Device]> { devicesSubject.asObserver() }
    
    private let selectedDeviceSubject = PublishSubject<Device>()
    var selectedDeviceObservable: Observable<Device> { selectedDeviceSubject.asObserver() }
    
    private let editModeSubject = BehaviorSubject<Bool>(value: false)
    var editModeObservable: Observable<Bool> { editModeSubject.asObserver() }
    
    private var devicesListNotFiltred: [Device] = []
    
    private let devicesFilter = DevicesFilter()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UseCases
    
    private let dataUseCase: DataUseCase
    private let deviceUseCase: DeviceUseCase
    
    // MARK: - Initializer
    
    init(dataUseCase: DataUseCase, deviceUseCase: DeviceUseCase) {
        self.dataUseCase = dataUseCase
        self.deviceUseCase = deviceUseCase
        
        observe()
    }
    
    // MARK: - Observe
    
    private func observe() {
        deviceUseCase.devicesObservable
            .subscribe(onNext: { [weak self] devices in
                self?.devicesListNotFiltred = devices
                self?.updateDevices()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update
    
    private func updateDevices() {
        devicesSubject.onNext(devicesFilter.filter(devices: devicesListNotFiltred))
    }
    
    // MARK: - Events
    
    func onViewDidLoad() {
        dataUseCase.refreshData()
    }
    
    func onDeviceTapped(_ device: Device) {
        selectedDeviceSubject.onNext(device)
    }
    
    func onFilterDeviceTypeChanged(_ deviceTypes: Set<DeviceType>) {
        devicesFilter.filterDeviceTypes = deviceTypes
        updateDevices()
    }
    
    func onEditTapped() {
        let currentEditMode = (try? editModeSubject.value()) ?? false
        editModeSubject.onNext(!currentEditMode)
    }
    
    func onDeleteDeviceTapped(_ device: Device) {
        deviceUseCase.deleteDevice(device)
    }
}
