//
//  DevicesListCoordinator.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 05/12/2021.
//

import UIKit
import RxSwift

class DevicesListCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        configureNavigationControllerDesign()
        goToDevicesList()
    }
    
    private func configureNavigationControllerDesign() {
        guard let navigationController = router.toPresentable() as? UINavigationController else {
            return
        }
        
        let navigationBar = navigationController.navigationBar
        navigationBar.barTintColor = UIColor(named: "White")
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "Black") ?? .black]
        navigationBar.shadowImage = UIImage() // To remove the line under the navigation bar
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
