//
//  AppCoordinator.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    
    // MARK: - Initializer
    
    init(_ window: UIWindow,
         _ appModule: AppModule = DefaultAppModule(),
         _ router: Router = DefaultRouter(navigationController: UINavigationController())) {
        self.window = window
        super.init(appModule: appModule, router: router)
        configureWindow()
    }
    
    // MARK: - Configurations
    
    private func configureWindow() {
        window.rootViewController = router.toPresentable()
        window.makeKeyAndVisible()
    }
    
    // MARK: - Actions
    
    override func start() {
        goToDevicesList()
    }
    
    private func goToDevicesList() {
        let devicesListViewModel = DevicesListViewModel(dataUseCase: appModule.dataUseCase,
                                                        deviceUseCase: appModule.deviceUseCase)
        let devicesListViewController = DevicesListViewController()
        devicesListViewController.viewModel = devicesListViewModel
        router.setRootModule(devicesListViewController, hideBar: false)
    }
}
