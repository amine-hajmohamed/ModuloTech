//
//  SliderView.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 03/12/2021.
//

import UIKit
import RxSwift

private let kSliderHeight: CGFloat = 250
private let kSliderWidth: CGFloat = 10
private let kThumbWidth: CGFloat = 24
private let kThumbBorderWidth: CGFloat = 6

class SliderView: UIView {
    
    // MARK: - View
    
    private var viewSliderTrack: UIView!
    private var viewSliderFilled: UIView!
    private var viewSliderThumb: UIView!
    private var labelMaxValue: UILabel!
    private var labelMinValue: UILabel!
    
    private var constraintViewSliderThumbBottom: NSLayoutConstraint!
    
    private var panGestureViewSliderThumb: UIPanGestureRecognizer!
    
    // MARK: - Properties
    
    private let valueSubject = BehaviorSubject<Float>(value: 0)
    var valueObservable: Observable<Float> { valueSubject.asObserver() }
    var value: Float { (try? valueSubject.value()) ?? 0 }
    
    private var maxValue: Float = 100
    private var minValue: Float = 0
    private var diffBetweenMaxAndMindValues: Float = 100
    private var step: Float = 1
    
    private var labelValueSuffix = ""
    private var showDecimalNumberIfEqualToZero = false
    
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
        updateMinAndMaxLabels()
        observe()
    }
    
    // MARK: - Configure
    
    func configureWith(value: Float,
                       minValue: Float,
                       maxValue: Float,
                       step: Float,
                       labelValueSuffix: String = "",
                       showDecimalNumberIfEqualToZero: Bool = false) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        self.labelValueSuffix = labelValueSuffix
        self.showDecimalNumberIfEqualToZero = showDecimalNumberIfEqualToZero
        self.diffBetweenMaxAndMindValues = maxValue - minValue
        updateMinAndMaxLabels()
        updateValue(value)
    }
    
    // MARK: - Observe
    
    private func observe() {
        valueSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.updateViewThumb()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update
    
    func updateValue(_ value: Float) {
        var value = value
        
        if value > maxValue {
            value = maxValue
        } else if value < minValue {
            value = minValue
        }
        
        value = round(value / step) * step
        
        if value != self.value {
            valueSubject.onNext(value)
        }
    }
    
    private func updateMinAndMaxLabels() {
        labelMinValue.text = minValue.toString(showDecimalNumberIfEqualToZero: showDecimalNumberIfEqualToZero) + labelValueSuffix
        labelMaxValue.text = maxValue.toString(showDecimalNumberIfEqualToZero: showDecimalNumberIfEqualToZero) + labelValueSuffix
    }
    
    private func updateViewThumb() {
        let percentageOfValue = (value - minValue) / diffBetweenMaxAndMindValues
        constraintViewSliderThumbBottom.constant = -(kSliderHeight * CGFloat(percentageOfValue) - kThumbWidth / 2)
    }
}

// MARK: - View
private extension SliderView {
    
    func loadView() {
        setupLabelMaxValue()
        setupViewSliderTrack()
        setupViewSliderFilled()
        setupViewSliderThumb()
        setupLabelMinValue()
        setupMainView()
    }
    
    func setupViewSliderThumb() {
        viewSliderThumb = UIView()
        viewSliderThumb.translatesAutoresizingMaskIntoConstraints = false
        viewSliderThumb.layer.cornerRadius = kThumbWidth / 2
        viewSliderThumb.layer.borderWidth = kThumbBorderWidth
        viewSliderThumb.layer.borderColor = UIColor(named: "DarkGray")?.cgColor
        viewSliderThumb.backgroundColor = UIColor(named: "White")
        
        panGestureViewSliderThumb = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        viewSliderThumb.addGestureRecognizer(panGestureViewSliderThumb)
        
        NSLayoutConstraint.activate([
            viewSliderThumb.heightAnchor.constraint(equalToConstant: kThumbWidth),
            viewSliderThumb.widthAnchor.constraint(equalToConstant: kThumbWidth),
        ])
    }
    
    func setupViewSliderFilled() {
        viewSliderFilled = UIView()
        viewSliderFilled.translatesAutoresizingMaskIntoConstraints = false
        viewSliderFilled.backgroundColor = UIColor(named: "Brown")
        viewSliderFilled.layer.cornerRadius = kSliderWidth / 2
        
        NSLayoutConstraint.activate([
            viewSliderFilled.widthAnchor.constraint(equalToConstant: kSliderWidth),
        ])
    }
    
    func setupViewSliderTrack() {
        viewSliderTrack = UIView()
        viewSliderTrack.translatesAutoresizingMaskIntoConstraints = false
        viewSliderTrack.backgroundColor = UIColor(named: "LightGray")
        viewSliderTrack.layer.cornerRadius = kSliderWidth / 2
        
        viewSliderTrack.layer.shadowColor = UIColor(named: "Black")?.cgColor
        viewSliderTrack.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewSliderTrack.layer.shadowOpacity = 0.1
        viewSliderTrack.layer.shadowRadius = 2
        
        NSLayoutConstraint.activate([
            viewSliderTrack.heightAnchor.constraint(equalToConstant: kSliderHeight),
            viewSliderTrack.widthAnchor.constraint(equalToConstant: kSliderWidth),
        ])
    }
    
    func setupLabelMaxValue() {
        labelMaxValue = UILabel()
        labelMaxValue.translatesAutoresizingMaskIntoConstraints = false
        labelMaxValue.textColor = UIColor(named: "DarkGray")
        labelMaxValue.textAlignment = .center
        
        labelMaxValue.layer.shadowColor = UIColor(named: "Black")?.cgColor
        labelMaxValue.layer.shadowOffset = CGSize(width: 1, height: 1)
        labelMaxValue.layer.shadowOpacity = 0.2
        labelMaxValue.layer.shadowRadius = 1
    }
    
    func setupLabelMinValue() {
        labelMinValue = UILabel()
        labelMinValue.translatesAutoresizingMaskIntoConstraints = false
        labelMinValue.textColor = UIColor(named: "DarkGray")
        labelMinValue.textAlignment = .center
        
        labelMinValue.layer.shadowColor = UIColor(named: "Black")?.cgColor
        labelMinValue.layer.shadowOffset = CGSize(width: 1, height: 1)
        labelMinValue.layer.shadowOpacity = 0.2
        labelMinValue.layer.shadowRadius = 1
    }
    
    func setupMainView() {
        addSubview(labelMaxValue)
        addSubview(viewSliderTrack)
        addSubview(viewSliderFilled)
        addSubview(viewSliderThumb)
        addSubview(labelMinValue)
        
        constraintViewSliderThumbBottom = viewSliderThumb.bottomAnchor.constraint(equalTo: viewSliderTrack.bottomAnchor)
        
        NSLayoutConstraint.activate([
            labelMaxValue.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            labelMaxValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelMaxValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            viewSliderTrack.topAnchor.constraint(equalTo: labelMaxValue.bottomAnchor, constant: 15),
            viewSliderTrack.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewSliderTrack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            viewSliderTrack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            viewSliderFilled.topAnchor.constraint(equalTo: viewSliderThumb.centerYAnchor),
            viewSliderFilled.bottomAnchor.constraint(equalTo: viewSliderTrack.bottomAnchor),
            viewSliderFilled.centerXAnchor.constraint(equalTo: viewSliderTrack.centerXAnchor),
            viewSliderThumb.centerXAnchor.constraint(equalTo: viewSliderTrack.centerXAnchor),
            constraintViewSliderThumbBottom,
            labelMinValue.topAnchor.constraint(equalTo: viewSliderTrack.bottomAnchor, constant: 15),
            labelMinValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelMinValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            labelMinValue.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
        ])
    }
}

// MARK: - Gestures
private extension SliderView {
    
    @objc func handleGesture(_ gesture: UIGestureRecognizer) {
        switch gesture {
        case panGestureViewSliderThumb:
            let distanceFromSliderBottom = kSliderHeight - panGestureViewSliderThumb.location(in: viewSliderTrack).y
            let percentageOfDistance = distanceFromSliderBottom / kSliderHeight
            let value = diffBetweenMaxAndMindValues * Float(percentageOfDistance) + minValue
            updateValue(value)
            
        default:
            break
        }
    }
}
