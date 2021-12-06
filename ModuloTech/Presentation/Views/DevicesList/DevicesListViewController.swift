//
//  DevicesListViewController.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import UIKit
import RxSwift

private let kColumnsPerRow = 2
private let kCellRatio: CGFloat = 1
private let kCellSpacing: CGFloat = 20

class DevicesListViewController: UIViewController {
    
    // MARK: - View
    
    private var devicesFilterView: DevicesFilterView!
    private var collectionViewDevicesList: UICollectionView!
    
    // MARK: - Properties
    
    var viewModel: DevicesListViewModel?
    
    private var devices: [Device] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "DevicesListViewController.Title".localized
        
        observe()
        viewModel?.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let collectionViewDevicesListLayout = collectionViewDevicesList.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewDevicesListLayout?.itemSize = calculateCellSize()
    }
    
    // MARK: - Observe
    
    private func observe() {
        viewModel?.devicesObservable
            .subscribe(onNext: { [weak self] devices in
                self?.update(with: devices)
            })
            .disposed(by: disposeBag)
        
        devicesFilterView.selectedDeviceTypesObservable
            .subscribe(onNext: { [weak self] selectedDeviceTypes in
                self?.viewModel?.onFilterDeviceTypeChanged(selectedDeviceTypes)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update
    
    private func update(with devices: [Device]) {
        self.devices = devices
        DispatchQueue.main.async { [weak self] in
            self?.collectionViewDevicesList.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DevicesListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let device = devices[indexPath.row]
        let cell = collectionView.dequeueReusableCell(with: DeviceCollectionViewCell.self, for: indexPath)
        cell.configure(with: device)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DevicesListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        viewModel?.onDeviceTapped(device)
    }
}

// MARK: - View
extension DevicesListViewController {
    
    override func loadView() {
        super.loadView()
        
        setupDevicesFilterView()
        setupCollectionViewDevicesList()
        setupMainView()
    }
    
    private func setupDevicesFilterView() {
        devicesFilterView = DevicesFilterView()
        devicesFilterView.translatesAutoresizingMaskIntoConstraints = false
        
        devicesFilterView.layer.shadowColor = UIColor(named: "Black")?.cgColor
        devicesFilterView.layer.shadowOffset = CGSize(width: 0, height: 5)
        devicesFilterView.layer.shadowOpacity = 0.25
        devicesFilterView.layer.shadowRadius = 3
    }
    
    private func setupCollectionViewDevicesList() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: kCellSpacing, left: kCellSpacing, bottom: kCellSpacing, right: kCellSpacing)
        layout.minimumLineSpacing = kCellSpacing
        layout.minimumInteritemSpacing = kCellSpacing
        
        collectionViewDevicesList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewDevicesList.translatesAutoresizingMaskIntoConstraints = false
        collectionViewDevicesList.backgroundColor = UIColor.clear
        collectionViewDevicesList.register(with: DeviceCollectionViewCell.self)
        collectionViewDevicesList.dataSource = self
        collectionViewDevicesList.delegate = self
    }
    
    private func setupMainView() {
        view.backgroundColor = UIColor(named: "White")
        
        view.addSubview(collectionViewDevicesList)
        view.addSubview(devicesFilterView)
        
        NSLayoutConstraint.activate([
            devicesFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            devicesFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            devicesFilterView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionViewDevicesList.topAnchor.constraint(equalTo: devicesFilterView.bottomAnchor),
            collectionViewDevicesList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionViewDevicesList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewDevicesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func calculateCellSize() -> CGSize {
        let availableWidh = collectionViewDevicesList.bounds.width -  kCellSpacing * CGFloat(kColumnsPerRow + 1)
        let cellWidth = floor(availableWidh / CGFloat(kColumnsPerRow))
        let cellHeight = cellWidth * kCellRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
