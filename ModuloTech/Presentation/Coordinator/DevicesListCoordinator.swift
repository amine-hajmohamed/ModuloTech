//
//  DevicesListCoordinator.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 05/12/2021.
//

import RxSwift

class DevicesListCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        goToDevicesList()
    }
    
    private func goToDevicesList() {
        let devicesListViewModel = DevicesListViewModel(dataUseCase: appModule.dataUseCase, deviceUseCase: appModule.deviceUseCase)
        devicesListViewModel.selectedDeviceObservable
            .subscribe(onNext: { [weak self] device in
                self?.goToDeviceControl(device)
            })
            .disposed(by: disposeBag)
        
        let devicesListViewController = DevicesListViewController()
        devicesListViewController.viewModel = devicesListViewModel
        router.push(devicesListViewController, animated: false) { [weak self] in
            self?.onCompletion?()
        }
    }
    
    private func goToDeviceControl(_ device: Device) {
        let deviceControlViewModel = DeviceControlViewModel(device: device, deviceUseCase: appModule.deviceUseCase)
        let deviceControlViewController = DeviceControlViewController()
        deviceControlViewController.viewModel = deviceControlViewModel
        router.push(deviceControlViewController, animated: true)
    }
}
