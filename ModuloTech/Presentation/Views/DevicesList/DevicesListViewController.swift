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
    
    private var barButtonEdit: UIBarButtonItem!
    private var devicesFilterView: DevicesFilterView!
    private var collectionViewDevicesList: UICollectionView!
    
    // MARK: - Properties
    
    var viewModel: DevicesListViewModel?
    
    var onDeviceSelectedObservable: Observable<Device>? { viewModel?.selectedDeviceObservable.asObservable() }
    
    private var devices: [Device] = []
    private var editMode = false
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
        
        viewModel?.editModeObservable
            .subscribe(onNext: { [weak self] editMode in
                self?.updateEditMode(editMode)
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
    
    private func updateEditMode(_ editMode: Bool) {
        self.editMode = editMode
        
        if editMode {
            barButtonEdit.title = "Done".localized
        } else {
            barButtonEdit.title = "Edit".localized
        }
        
        collectionViewDevicesList.reloadData()
    }
}

// MARK: - Actions
extension DevicesListViewController {
    
    @objc private func barButtonTapped(_ sender: UIBarButtonItem) {
        switch sender {
        case barButtonEdit:
            viewModel?.onEditTapped()
            
        default:
            break
        }
    }
    
    private func deleteDeviceTapped(_ device: Device) {
        let alertTitle = "Alert.DeleteDevice.Title".localized
        let alertMessage = String(format: "Alert.DeleteDevice.Message".localized, device.name)
        
        let alertCancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let alertDeleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] _ in
            self?.viewModel?.onDeleteDeviceTapped(device)
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(alertCancelAction)
        alertController.addAction(alertDeleteAction)
        present(alertController, animated: true, completion: nil)
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
        cell.configure(with: device, editMode: editMode)
        cell.onButtonDeleteTappedObservable
            .subscribe(onNext: { [weak self] in
                self?.deleteDeviceTapped(device)
            })
            .disposed(by: cell.disposeBag)
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
        
        setupButtonEdit()
        setupDevicesFilterView()
        setupCollectionViewDevicesList()
        setupMainView()
    }
    
    private func setupButtonEdit() {
        barButtonEdit = UIBarButtonItem(title: nil,
                                        style: .plain,
                                        target: self,
                                        action: #selector(barButtonTapped))
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
        
        navigationItem.rightBarButtonItem = barButtonEdit
        
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
